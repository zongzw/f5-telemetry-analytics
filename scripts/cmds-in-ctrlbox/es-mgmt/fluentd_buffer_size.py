import subprocess
import os
import glob
import re

def get_subfolder_size(folder):
    datadir = folder

    rlt = {}
    for n in glob.glob(datadir + "/*"):
        try:
            r = subprocess.check_output("du -sb %s" % n, shell=True)
            sr = str(r).strip()

            matched = re.match("^(\d+)\s+(.*)$", sr)
            if matched: 
                worker_name = os.path.basename(matched.group(2))
                folder_size = int(matched.group(1))
                print(worker_name, folder_size)
                rlt[worker_name] = folder_size
        except Exception as e:
            print("failed to get size of %s: %s" % (n, e.message))

    return rlt

# print(get_subfolder_size(datadir))