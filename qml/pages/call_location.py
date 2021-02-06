# import pyotherside
# We use a custom location
import sys

sys.path.append("/usr/share/harbour-infraview/python/")
from requests import get  # not available by default!


def get_geolocation():
    """get geolocation using external IP"""
    geo_info = {}
    try:
        ext_ip = get("https://api.ipify.org").text
        headers = {
            'User-Agent': 'keycdn-tools:https://example.com'
        }
        query = get(url="https://tools.keycdn.com/geo.json?host=" + ext_ip, headers=headers)
        result = query.json()
        geo_info["latitude"] = result["data"]["geo"]["latitude"]
        geo_info["longitude"] = result["data"]["geo"]["longitude"]
        geo_info["timezone"] = result["data"]["geo"]["timezone"]
        geo_info["continent_code"] = result["data"]["geo"]["continent_code"]
        geo_info["country_code"] = result["data"]["geo"]["country_code"]
        geo_info["country_name"] = result["data"]["geo"]["country_name"]
        geo_info["city"] = result["data"]["geo"]["city"]
        geo_info["postal_code"] = result["data"]["geo"]["postal_code"]
        geo_info["isp"] = result["data"]["geo"]["isp"]
        geo_info["host"] = result["data"]["geo"]["host"]
        geo_info["rdns"] = result["data"]["geo"]["rdns"]

        return geo_info
    except BaseException:
        return {"latitude": "Error"}
