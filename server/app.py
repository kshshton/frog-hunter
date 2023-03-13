from fastapi import FastAPI
from scrape.api import FrogAPI

app = FastAPI()


@app.get("/query")
async def read_geolocation(city: str):
    api = FrogAPI(city)
    return {
        api.frogs_in_city()
    }
