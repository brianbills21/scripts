#!/usr/bin/python3
import json,urllib.request,difflib,datetime,smtplib,os,email.message,csv,sys,base64
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import date
from email.message import EmailMessage

diff = difflib.Differ()

def createEnv(name, url):
    env = dict(name=name, url=url)
    return env

def create(torranceEnvName, torranceEnvUrl, austinName, austinUrl):
    torranceEnv = createEnv(torranceEnvName, torranceEnvUrl)
    austinEnv = createEnv(austinName, austinUrl)
    env = dict(torranceEnv=torranceEnv, austinEnv=austinEnv)
    return env



def normalizeAustinValues(imageTag):
    austinHost = 'dr-harbor.docmagic.com'
    torranceHost = 'harbor.docmagic.com'
    if (austinHost in imageTag):
        imageTag = imageTag.replace(austinHost, torranceHost)
    return imageTag

def compareEnvironmentTags(torranceEnv, austinEnv, report_file):

    data_1 = urllib.request.urlopen(torranceEnv['url']).read()
    data_2 = urllib.request.urlopen(austinEnv['url']).read()

    torrance_dict = json.loads(data_1)
    austin_dict = json.loads(data_2)

    missing_in_torrance = []
    missing_in_austin = []
    check_for_diffs = []

    for i in austin_dict:
        if (i not in torrance_dict):
            missing_in_torrance.append(i)

    for i in torrance_dict:
        if (i not in austin_dict):
            missing_in_austin.append(i)
        else:
            check_for_diffs.append(i)

    for i in missing_in_torrance:
        print('\tmissing in torrance: ', i, file=report_file)
    for i in missing_in_austin:
        print('\tmissing in austin  : ', i, file=report_file)

    print(file=report_file)
    for i in check_for_diffs:
        
        torrance_images = torrance_dict[i][torranceEnv['name']]['images']
        austin_images = austin_dict[i][austinEnv['name']]['images']

        torrance_images = list(torrance_images)
        austin_images = list(austin_images)
        normalized_austin_images = list(map(normalizeAustinValues, austin_images))
        
        torrance_images.sort()
        austin_images.sort()
        normalized_austin_images.sort()

        result = diff.compare(torrance_images, normalized_austin_images)
        result = [line for line in result if line.startswith(("- ", "+ "))]
        result = ''.join(result)

        if (result): 
            print('\t', i, file=report_file)
            
            if (len(torrance_images) != len(austin_images)):
                torrance_not_in_austin = set(torrance_images).difference(normalized_austin_images)
                austin_not_in_torrance = set(normalized_austin_images).difference(torrance_images)  
                print('\t\t torrance', file=report_file)
                for image in torrance_not_in_austin:
                    print('\t\t\t', image, file=report_file)
                print('\t\t austin', file=report_file)
                for image in austin_not_in_torrance:
                    print('\t\t\t','dr-', image, file=report_file)
            else:
                for idx,image in enumerate(torrance_images):
                    if (image != normalized_austin_images[idx]):
                        print('\t\t torrance', file=report_file)
                        print('\t\t\t ', image, file=report_file)
                        print('\t\t austin', file=report_file)
                        print('\t\t\t ', austin_images[idx], file=report_file)

    return #compareEnvironmenTags

### execution block

environments = []
environments.append(create("docmagic-prod-torrance", "https://gitops-service.docmagic.com/argocd/compare/docmagic-prod-torrance", "docmagic-prod-austin", "https://gitops-service.docmagic.com/argocd/compare/docmagic-prod-austin"))
environments.append(create("docmagic-dev-torrance", "https://gitops-service.docmagic.com/argocd/compare/docmagic-dev-torrance", "docmagic-dev-austin", "https://gitops-service.docmagic.com/argocd/compare/docmagic-dev-austin"))
environments.append(create("uwm-prod-torrance", "https://gitops-service.docmagic.com/argocd/compare/uwm-prod-torrance", "uwm-prod-austin", "https://gitops-service.docmagic.com/argocd/compare/uwm-prod-austin"))
environments.append(create("eps-prod-torrance", "https://gitops-service.docmagic.com/argocd/compare/eps-prod-torrance", "eps-prod-austin", "https://gitops-service.docmagic.com/argocd/compare/eps-prod-austin"))
environments.append(create("jpmc-prod-torrance", "https://gitops-service.docmagic.com/argocd/compare/jpmc-prod-torrance", "jpmc-prod-austin", "https://gitops-service.docmagic.com/argocd/compare/jpmc-prod-austin"))
environments.append(create("wf-prod-torrance", "https://gitops-service.docmagic.com/argocd/compare/wf-prod-torrance", "wf-prod-austin", "https://gitops-service.docmagic.com/argocd/compare/wf-prod-austin"))

with open('report.txt', 'w') as report_file:
    for env in environments:
        print(env['torranceEnv']['name'], ' vs ', env['austinEnv']['name'], file=report_file)
        compareEnvironmentTags(env['torranceEnv'], env['austinEnv'], report_file)
        print(file=report_file)

# Sender and recipient
me = 'itops@docmagic.com'
you = 'itops@docmagic.com'      
# Open the plain text file whose name is in textfile for reading.
textfile = 'report.txt'
with open(textfile) as fp:
    # Create a text/plain message
    msg = EmailMessage()
    msg.set_content(fp.read())

# me == the sender's email address
# you == the recipient's email address
date = datetime.datetime.now().strftime('%m-%d-%Y')
msg['Subject'] = f'Image Diff Report %s' % date
msg['From'] = me
msg['To'] = you

# Send the message via our own SMTP server.
s = smtplib.SMTP('smtp-gateway.docmagic.com:25')
s.send_message(msg)
s.quit()
os.remove("report.txt")