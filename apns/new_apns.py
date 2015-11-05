import time
import json

from apns import APNs, Frame, Payload
import sys

cert_file = 'cert.pem'
json_file = 'payload.json'

tokens = [
    '74EFFB57F7D081B88AF222861ACC9BEA45F8B257EB1762D82265F494C6E1178D',
]

if __name__ == '__main__':
    try:
        custom_payload = json.loads(open(json_file, 'r').read())
    except Exception:
        sys.exit('Incorrect JSON')

    apns = APNs(use_sandbox=True, cert_file=cert_file, enhanced=True)

    payload = Payload(custom=custom_payload)

    # Send multiple notifications in a single transmission
    frame = Frame()
    for i, token in enumerate(tokens, start=1):
        frame.add_item(token, payload, i, time.time() + 3600, 10)

    apns.gateway_server.send_notification_multiple(frame)

    def response_listener(error_response):
        print(error_response)

    apns.gateway_server.register_response_listener(response_listener)
