"""
To experiment with this code freely you will have to run this code locally.
Take a look at the main() function for an example of how to use the code. We
have provided example json output in the other code editor tabs for you to look
at, but you will not be able to run any queries through our UI.
"""
import json
import requests

BASE_URL = "http://musicbrainz.org/ws/2/"
ARTIST_URL = BASE_URL + "artist/"


# query parameters are given to the requests.get function as a dictionary; this
# variable contains some starter parameters.
query_type = {  "simple": {},
                "atr": {"inc": "aliases+tags+ratings"},
                "aliases": {"inc": "aliases"},
                "releases": {"inc": "releases"}}


def query_site(url, params, uid="", fmt="json"):
    """
    This is the main function for making queries to the musicbrainz API. The
    query should return a json document.
    """
    params["fmt"] = fmt
    r = requests.get(url + uid, params=params)
    print ("requesting " + r.url)

    if r.status_code == requests.codes.ok:
        return r.json()
    else:
        r.raise_for_status()


def query_by_name(url, params, name):
    """
    This adds an artist name to the query parameters before making an API call
    to the function above.
    """
    params["query"] = "artist:" + name
    return query_site(url, params)


def pretty_print(data, indent=4):
    """
    After we get our output, we can use this function to format it to be more
    readable.
    """
    if type(data) == dict:
        print (json.dumps(data, indent=indent, sort_keys=True))
    else:
        print (data)


def main():
    """
    Below is an example investigation to help you get started in your
    exploration. Modify the function calls and indexing below to answer the
    questions on the next quiz.

    HINT: Note how the output we get from the site is a multi-level JSON
    document, so try making print statements to step through the structure one
    level at a time or copy the output to a separate output file. Experimenting
    and iteration will be key to understand the structure of the data!
    """

    # Query for information in the database about bands named Nirvana
    results = query_by_name(ARTIST_URL, query_type["simple"], "First aid kit")

    lstArtistas = results['artists']
    count = 0
    for i in range(len(lstArtistas)):
        if lstArtistas[i]['name'].upper() == "FIRST AID KIT":
            count = count + 1

    print ("How many bands named First Aid Kit? " + str(count))

    results = query_by_name(ARTIST_URL, query_type["simple"], "Queen")
    lstArtistas = results['artists']

    for i in range(len(lstArtistas)):
        if lstArtistas[i]['name'].upper() == "QUEEN":
            if("begin-area" in lstArtistas[i]):
                print ("Begin-area name for Queen? " +lstArtistas[i]['begin-area']['name'])

    results = query_by_name(ARTIST_URL, query_type["simple"], "Beatles")
    lstArtistas = results['artists']

    for i in range(len(lstArtistas)):
        if lstArtistas[i]['name'].upper() == "THE BEATLES":
            artist_id = lstArtistas[i]["id"]
            dctRetorno = query_site(ARTIST_URL, query_type["aliases"], artist_id)
            lstAliases = dctRetorno["aliases"]

            for j in range(len(lstAliases)):
                if "locale" in lstAliases[j] and "name" in lstAliases[j]:
                    if lstAliases[j]['locale'] == "es":
                        print("Spanish alias for Beatles? " + lstAliases[j]['name'])

    results = query_by_name(ARTIST_URL, query_type["simple"], "Nirvana")
    lstArtistas = results['artists']

    for i in range(len(lstArtistas)):
        if "tags" in lstArtistas[i]:
            lstTags = lstArtistas[i]['tags']
            for j in range(len(lstTags)):
                if lstTags[j]['name'].upper() == "KURT COBAIN":
                    print("Nirvana disambiguation? " + lstArtistas[i]['disambiguation'])

    results = query_by_name(ARTIST_URL, query_type["simple"], "One Direction")
    lstArtistas = results['artists']

    for i in range(len(lstArtistas)):
        if lstArtistas[i]['name'].upper() == "ONE DIRECTION":
            if "life-span" in lstArtistas[i]:
                 print("When was One Direction formed? " + lstArtistas[i]['life-span']['begin'])





            #    print(lstAliases(j))
            #for j in lstAliases:
            #    print (lstAliases[j])
            #for j in range(len(lstAliases)):
            #    pretty_print(lstAliases[j])
                #if "locale" in lstAliases[j]:
                #    if lstAliases[j]['locale'].upper() == "ES":
                #        print ("Spanish alias for Beatles?" + lstAliases[j]['locale'])

            #pretty_print(artist_data)
            #b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d
#            if("begin-area" in lstArtistas[i]):
#                print ("Begin-area name for Queen? " +lstArtistas[i]['begin-area']['name'])

#    pretty_print(results)

# Spanish alias for Beatles?
# Nirvana disambiguation?
# When was One Direction formed?

    #pretty_print(results)

    # Isolate information from the 4th band returned (index 3)
    #print "\nARTIST:"
    #pretty_print(results["artists"][3])

    # Query for releases from that band using the artist_id
    #artist_id = results["artists"][3]["id"]
    #print "\nArtist id:"
    #print artist_id
    #artist_data = query_site(ARTIST_URL, query_type["releases"], artist_id)
    #releases = artist_data["releases"]

    # Print information about releases from the selected band
    #print "\nONE RELEASE:"
    #pretty_print(releases[0], indent=2)

    #release_titles = [r["title"] for r in releases]
    #print "\nALL TITLES:"
    #for t in release_titles:
    #    print t

if __name__ == '__main__':
    main()
