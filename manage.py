import argparse
import subprocess, os

parser=argparse.ArgumentParser(description="Decrypt files")

parser.add_argument('file', type=str, help="Absolute path to encrypted file")
parser.add_argument('-o','--stdout', action='store_true', help="show the file in stdout only")
parser.add_argument('-k','--key', type=str, default="/ramdisk/file.key", help="Key to encrypt/decrypt files")

def decryptFile(filePath, output=False, key="/ramdisk/file.key"):
    src,name=filePath.rsplit('/',1)
    outfile="/ramdisk/%s"%('../dev/stdout' if output else name[:-4])
    p=subprocess.Popen(['aescrypt','-d','-k',key,'-o',outfile,filePath], stdout=subprocess.PIPE)
    if output != False:
        return p.communicate()[0]



args=parser.parse_args()
print decryptFile(args.file, output=args.stdout, key=args.key)
