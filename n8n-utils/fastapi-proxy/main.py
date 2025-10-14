from fastapi import FastAPI
from jobspy import scrape_jobs
import numpy as np
app = FastAPI()

@app.get("/job_search")
async def job_search():
    jobs = scrape_jobs(
        site_name=["linkedin", "google"], # "glassdoor", "bayt", "naukri", "bdjobs"
        search_term="Python Django Backend Developer",
        google_search_term="Django Python Jobs in India since yesterday",
        location="Noida, Uttar Pradesh",
        results_wanted=20,
        hours_old=72,
        country_indeed='India',
    )
    jobs = jobs.replace([np.inf, -np.inf, np.nan], None) # replaces Nan to None for json conversion
    return jobs.to_dict(orient="records")