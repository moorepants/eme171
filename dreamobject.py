import os

import boto

course = 'eme171'
year = '2020'
quarter = 'w'  # f: fall, w: winter, s: spring

accepted_file_exts = ['.pdf', '.png', '.gif', '.mp4', '.jpg']

conn = boto.connect_s3(host='objects-us-east-1.dream.io')

bucket = conn.get_bucket(course)

assets_dir = 'assets'

files = os.listdir(assets_dir)

for fname in files:
    if os.path.splitext(fname)[-1] in accepted_file_exts:
        print('Uploading: {}'.format(fname))
        key = boto.s3.key.Key(bucket, '{}{}/{}'.format(year, quarter, fname))
        key.set_contents_from_filename(os.path.join(assets_dir, fname))
    else:
        print('Skipping: {}'.format(fname))

for o in bucket.list():
    o.set_acl('public-read')
