import os

import boto

course = 'eme171'
year = '2019'

conn = boto.connect_s3(host='objects-us-east-1.dream.io')

bucket = conn.get_bucket(course)

pdf_dir = '/home/moorepants/Nextcloud/Teaching/{}/'.format(course)

files = os.listdir(pdf_dir)

for fname in files:
    if fname.endswith('.pdf'):
        print('Uploading {}'.format(fname))
        key = boto.s3.key.Key(bucket, 'lecture-notes/{}/{}'.format(year, fname))
        key.set_contents_from_filename(os.path.join(pdf_dir, fname))

for o in bucket.list():
    o.set_acl('public-read')
