from typing import Generator
from urllib.parse import quote

import requests


class FrogAPI():
    """Object made for controlling requests and responses of API"""
    city: str
    url: str
    headers: dict
    params: dict
    data: str
    

    def __init__(self, city: str) -> object:
        self.city = city[0].upper() + city[1:].lower()
        self.url = 'https://apkykk0pza-dsn.algolia.net/1/indexes/prod_locator_prod_zabka/query'
        self.headers = {
            'Connection': 'keep-alive',
            'Origin': 'https://www.zabka.pl',
            'Referer': 'https://www.zabka.pl/',
            'Sec-Fetch-Dest': 'empty',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Site': 'cross-site',
            'accept': 'application/json',
            'accept-language': 'pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7',
            'content-type': 'application/x-www-form-urlencoded',
            'sec-ch-ua-mobile': '?0',
        }
        self.params = {
            'x-algolia-agent': 'Algolia for vanilla JavaScript 3.22.1',
            'x-algolia-application-id': 'APKYKK0PZA',
            'x-algolia-api-key': '71ca67cda813cec86431992e5e67ede2',
        }
        self.data = '{"params":"query=' + quote(city.lower()) + '&hitsPerPage=900&page=0"}'


    def _get_response_of_post_request(self):
        return requests.post(
            url=self.url,
            params=self.params,
            headers=self.headers,
            data=self.data,
        )


    def frogs_in_city(self) -> Generator[dict, dict, dict]:
        response = self._get_response_of_post_request()
        locations = response.json()['hits']
        for location in locations:
            if location['city'] == self.city:
                yield location['_geoloc']
