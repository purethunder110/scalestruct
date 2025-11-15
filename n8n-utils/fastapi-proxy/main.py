from fastapi import FastAPI,Request
from jobspy import scrape_jobs
import numpy as np
import logging

log = logging.getLogger(__name__)

app = FastAPI()

@app.get("/job_search")
async def job_search(request:Request):
    # site_name,search_term,google_search_term,location,results_wanted,hours_old,country_indeed
    json_data = await request.json()
    jobs = scrape_jobs(
        **json_data
    )
    jobs = jobs.replace([np.inf, -np.inf, np.nan], None) # replaces Nan to None for json conversion
    return jobs.to_dict(orient="records")