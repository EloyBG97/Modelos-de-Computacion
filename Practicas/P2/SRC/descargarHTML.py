import requests
import sys
import os

def download(url):
    r = requests.get(url)
    if r.status_code != 200:
        sys.stderr.write("Error al obtener la URL".format(r.status_code, url))
        return None

    return r.text


if __name__ == '__main__':
    reload(sys)
    sys.setdefaultencoding('utf-8')
    url = str(sys.argv[1])
    r = download(url)

    if r:
        f = open("./video.html", "w")
        f.write(r)
	f.close();

    else:
       sys.stdout.write("No se ha encontrado la URL")
