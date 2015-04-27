How to use large files in your profile module


For each demo, you want to make a profile, for example, the sqlserver demo should be called:

tse_sqlserver

For the large files you want to use in this profile, you do not want them in your repo, instead, you want to upload the files to S3, take a checksum of the file as well (available in S3 for you after you uplaod it), put it in the hierarchy of

for example:
s3.amazonaws.com/tseteam/demo_files/$profilename/largefile.iso

in your files directory create a staging.yaml with the content of:
---
largefile.iso: 'md5sum_of_file'
evenlargerfile.iso: 'md5sum_of_file'

The masters demo_files class with reference these and stage them at a predictable URLs for you:

puppet:///demo_files/$profilename/largefile.iso
http://$master/demo_files/$profilename/largefile.iso
smb://$master/demo_files/$profilename/largefile.iso

You can then use remote_file, puppet file, to retrieve them or use the 'attach_master' on windows to attach the smb share as the Z drive / unc path on your machines to then reference for use later.



