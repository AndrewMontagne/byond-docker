import requests, re, zipfile, io, shutil, os

byond_data = requests.get('http://www.byond.com/download/build/LATEST/').text

regex = re.compile('>(\d+)\.(\d+)_byond_linux.zip<\/a> (\d{2}-\w{3}-\d{4} \d{2}:\d{2})')
parsed_data = regex.findall(byond_data)

minor_ver = 0
major_ver = 0
max_minor = None
max_major = 514

for tuple in parsed_data:
    parsed_major = int(tuple[0])
    parsed_minor = int(tuple[1])
    if parsed_major > major_ver and (max_major is not None and parsed_major <= max_major):
        major_ver = parsed_major
        minor_ver = parsed_minor

    if parsed_minor > minor_ver and (max_minor is not None and parsed_minor <= max_minor):
        minor_ver = int(tuple[1])
        
url = 'http://www.byond.com/download/build/%i/%i.%i_byond_linux.zip' % (major_ver, major_ver, minor_ver)

VERSION_FILENAME = './byond_version.txt'

if os.path.isfile(VERSION_FILENAME):
    with open(VERSION_FILENAME, 'r') as f:
        version_string = f.read()
        if version_string == ('%i.%i' % (major_ver, minor_ver)):
            print('Already up to date!')
            exit(0)

with open(VERSION_FILENAME, 'w') as f:
    f.write('%i.%i' % (major_ver, minor_ver))

print('Installing BYOND %i.%i...' % (major_ver, minor_ver))

request = requests.get(url)
zip = zipfile.ZipFile(io.BytesIO(request.content))
if os.path.isdir('./byond'):
    shutil.rmtree('./byond')
zip.extractall()

print('Done!')

