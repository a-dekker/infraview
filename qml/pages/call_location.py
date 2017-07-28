# import pyotherside
# We use a custom location
import sys
sys.path.append("/usr/share/harbour-infraview/python/")
from requests import get  # not available by default!


def get_geolocation():
    """get geolocation using external IP"""
    try:
        ext_ip = get('https://api.ipify.org').text
        r = get(url='https://tools.keycdn.com/geo.json?host=' + ext_ip)
        result = (r.json())
        latitude = result['data']['geo']['latitude']
        longitude = result['data']['geo']['longitude']
        timezone = result['data']['geo']['timezone']
        continent_code = result['data']['geo']['continent_code']
        country_code = result['data']['geo']['country_code']
        country_name = result['data']['geo']['country_name']
        city = result['data']['geo']['city']
        postal_code = result['data']['geo']['postal_code']
        isp = result['data']['geo']['isp']
        host = result['data']['geo']['host']
        rdns = result['data']['geo']['rdns']

        return latitude, longitude, timezone, continent_code, country_code, country_name, city, postal_code, isp, host, rdns
    except:
        return "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown"
