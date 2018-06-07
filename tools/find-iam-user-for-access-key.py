import boto.iam
import sys

iam = boto.connect_iam()

users = iam.get_all_users('/')['list_users_response']['list_users_result']['users']

for user in users:
    for key_result in iam.get_all_access_keys(user['user_name'])['list_access_keys_response']['list_access_keys_result']['access_key_metadata']:
            aws_access_key = key_result['access_key_id']
            for TARGET_ACCESS_KEY in sys.argv[1:]:
                if aws_access_key == TARGET_ACCESS_KEY:
                        print aws_access_key + ' : ' + user['user_name']

