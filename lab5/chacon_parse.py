import json
import pandas as pd 

#from directions, import the json file
with open('data/schacon.repos.json', 'r') as file:
    data = json.load(file)

#use option b for iii

#list for the entries with the relevant data from the directions  - name, html_url, updated_at, visibility
repo_list = []

#go through the first 5 repos (lines), for each one, we create a python dictionary that stores only the above info we want.
#use the .get() function to access the necessary fields from our current iteration (repo) from json data
for repo in data[:5]:
    repo_info = { "name": repo.get("name", ""),
        "html_url": repo.get("html_url", ""),
        "updated_at": repo.get("updated_at", ""),
        "visibility": repo.get("visibility", "")}
    repo_list.append(repo_info) #for each iteration, store the specified repo info in our list of repos

#convert list to a pandas dataframe
df = pd.DataFrame(repo_list)

#export using to_csv.  In order to match the directions, we have to remove the headers and index
df.to_csv("chacon.csv", index=False, header=False)

