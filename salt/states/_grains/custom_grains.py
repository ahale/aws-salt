import requests

MAGIC_URL = 'http://169.254.169.254/latest/meta-data'

def environment():
    try:
        env_resp = requests.get('%s/security-groups' % MAGIC_URL)
        inst_id_resp = requests.get('%s/instance-id' % MAGIC_URL)
        return {'environment': env_resp.content.split('-')[0],
                'instance_id': inst_id_resp.content,
                }
    except:
        pass
