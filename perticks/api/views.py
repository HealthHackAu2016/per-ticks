from django.http import HttpResponse, JsonResponse
from django.shortcuts import render
from api.models import BiteReport, HospitalData, Reminders
from datetime import datetime
import time
import hashlib
import requests
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import urllib2
import json
import smtplib
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.shortcuts import redirect
from django.contrib.auth import login, logout
import cStringIO as StringIO

try:
    import local_apikeys as apikeys
except ImportError, exp:
    import apikeys


def csv_download(request):
    print("downlading")
    csv = StringIO.StringIO()
    csv.write("id, auth_id, auth_code, email, phone, allows_follow_up, wants_reminder, symptom_comments, submission_date, bite_date, lat, lon, bitten_before, number_of_bites\n")
    bites = BiteReport.objects.all().order_by('submission_date')
    for bite in bites:
        csv.write(str(bite.id) + ", " + str(bite.auth_id) + ", " + str(bite.auth_code) + ", " + str(bite.email) + ", " + str(bite.phone) + ", " + str(bite.allows_follow_up) + ", " + str(bite.wants_reminder) + ", " + str(bite.symptom_comments) + ", " + str(bite.submission_date) + ", " + str(bite.bite_date) + ", " + str(bite.lat) + ", " + str(bite.lon) + ", " + str(bite.bitten_before) + ", " + str(bite.number_of_bites) + "\n")

    response = HttpResponse(csv.getvalue(), content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename=TickBites.csv'
    return response


def static_homepage(request):
    return render(request, 'about.html', {'titleValue': "Welcome"})


def static_about(request):
    return render(request, 'about.html', {'titleValue': "Welcome"})


def static_tickremoval(request):
    return render(request, 'tick-removal.html', {'titleValue': "Tick Removal"})


def research_login(request):
    return render(request, 'login.html', {'titleValue': "Researcher Login"})


def research_view(request):
    bites = BiteReport.objects.all()
    bite_list = []
    for bite in bites:
        bite_list.append({'lat': bite.lat, 'lon': bite.lon, 'date': bite.submission_date})
    return render(request, 'researcher-area.html', {'titleValue': "Researcher View", 'mapsApiKey': apikeys.GEOCODER_KEY, 'biteList': bite_list})


def report_bite(request):
    return render(request, 'report-tick-bite.html', {'titleValue': "Report Bite", 'mapsApiKey': apikeys.GEOCODER_KEY})


def bite_map(request):
    bites = BiteReport.objects.all()
    bite_list = []
    for bite in bites:
        bite_list.append({'lat': bite.lat, 'lon': bite.lon, 'date': bite.submission_date})
    return render(request, 'tick-bite-map.html', {'titleValue': "View Bite Map", 'mapsApiKey': apikeys.GEOCODER_KEY, 'biteList': bite_list})


def update_report(request):
    return render(request, 'update-report.html', {'titleValue': "Update Tick Report"})


# 2 Legit 2 Quit
@csrf_exempt
def hospital_endpoint(request):
    # The 'constants' for this function.
    GEOCODER_URL = "https://maps.googleapis.com/maps/api/geocode/json?key=" + \
        apikeys.GEOCODER_KEY + "&address="
    ME_DEBUG = False
    # Use this list to return some data.
    return_list = []
    # Fetch all data.
    all_hospitals = HospitalData.objects.all()
    # For each hospital in our file.
    for each_hospital in all_hospitals:
        # Do the geocoding.
        geocoder_address = GEOCODER_URL + each_hospital.hospital_address + ", Australia"
        the_json = (requests.get(geocoder_address)).json()
        # Get the lat and long.
        lat = the_json['results'][0]['geometry']['location']['lat']
        long = the_json['results'][0]['geometry']['location']['lng']
        # Get the existing data.
        name = each_hospital.hospital_name
        phone = each_hospital.hospital_telephone
        # Add it in to the list.
        return_list.append([name, phone, lat, long])
    return JsonResponse(return_list, safe=False)


@csrf_exempt
def submit(request):

    update = False
    if 'id' in request.POST and 'code' in request.POST:
        update = True

    required_properties = ['followup', 'symptoms', 'date', 'lat', 'lon', 'prevbite']

    # Check for compliance
    for p in required_properties:
        if p not in request.POST:
            # Uhoh.
            string = ""
            for a in request.POST:
                string += str(a) + ", "
            return HttpResponse("Error. Received: " + string, content_type="text/plain")

    # Save all of the submitted data.
    if not update:
        report = BiteReport()

    else:
        report = BiteReport().objects.get(auth_id=request.POST['id'], auth_code=request.POST['code'])

    if 'email' in request.POST:
        report.email = request.POST['email']

    if (('phone' in request.POST) and (str(request.POST['phone']) is not '') and (request.POST['phone'] is not None)):
        report.phone = request.POST['phone']

    if request.POST['followup'] == 'on':
        report.allows_follow_up = True

    report.symptom_comments = request.POST['symptoms']
    report.bite_date = datetime.strptime(request.POST['date'], '%d/%m/%Y')  # ('Jun 1 2005  1:33PM', '%b %d %Y %I:%M%p')
    report.lat = request.POST['lat']
    report.lon = request.POST['lon']

    if request.POST['prevbite'] == 'on':
        report.bitten_before = True

    if 'numbites' in request.POST:
        report.number_of_bites = request.POST['numbites']

    # Generate the auth details.
    cur_time = time.time()
    h1 = hashlib.sha256()
    h1.update(unicode(cur_time))
    report.auth_id = str(h1.hexdigest()[:5])

    h2 = hashlib.sha512()
    h2.update(unicode(cur_time))
    report.auth_code = str(h2.hexdigest()[:5])

    # If we got an email or phone number, send the auth details.
    if (('phone' in request.POST) and (str(request.POST['phone']) is not '') and (request.POST['phone'] is not None)):
        send_sms(report, 'Your tick bite report ID: ' + report.auth_id + ' and access code: ' + report.auth_code + '   Visit http://austick.auspollster.xyz for more information.')

    report.save()

    if request.POST['followup'] == 'on' and (('phone' in request.POST) and (str(request.POST['phone']) is not '') and (request.POST['phone'] is not None)):
        r = Reminders()
        r.report = report
        r.reminder_date = datetime.today()  # Plus 5 days.
        r.save()

    return redirect('/')


def send_sms(report, text):
    auth_request = requests.post("https://api.telstra.com/v1/oauth/token", data={
        'client_id': apikeys.tapi_consumer_key,
        'client_secret': apikeys.tapi_consumer_secret,
        'grant_type': 'client_credentials',
        'scope': 'SMS'})

    auth_response = auth_request.json()
    if 'access_token' not in auth_response:
        # Uhoh.
        print("An error occured with the Auth Request.")

    else:
        # Send the SMS.
        smsdata = {'to': report.phone, 'body': text}
        headers = {'Content-type': 'application/json', 'Authorization': 'Bearer ' + str(auth_response['access_token'])}
        url = "https://api.telstra.com/v1/sms/messages"

        req = urllib2.Request(url, headers=headers, data=json.dumps(smsdata))
        msg = urllib2.urlopen(req)


@csrf_exempt
def fetch(request):

    required_properties = ['id', 'code']

    for p in required_properties:
        if p not in request.POST:
            # Uhoh.
            return HttpResponse("Error", content_type="text/plain")

    br = BiteReport.objects.filter(auth_id=request.POST['id'], auth_code=request.POST['code'])

    if len(br) == 0:
        # Uhoh.
        return HttpResponse("Error", content_type="text/plain")

    else:
        b = br[0]
        ret_dict = {
            'email': b.email,
            'phone': b.phone,
            'allows_follow_up': b.allows_follow_up,
            'wants_reminder': b.wants_reminder,
            'comments': b.symptom_comments,
            'date': b.bite_date,
            'lat': b.lat,
            'lon': b.lon,
            'prevbite': b.bitten_before,
            'numbites': b.number_of_bites,
        }

        return JsonResponse(ret_dict)


@csrf_exempt
def do_login(request):

    user_id = ''
    if 'user_id' in request.POST:
        user_id = request.POST['user_id']

    user_pass = ''
    if 'user_pass' in request.POST:
        user_pass = request.POST['user_pass']

    if user_id is not '' and user_pass is not '':
        user = authenticate(username=user_id, password=user_pass)
        if user is not None:
            login(request, user)
            return redirect(request.POST['redirect'])

        else:
            return redirect('/')

    else:
        return redirect('/')


def do_logout(request):
    logout(request)
    return redirect('/')


def send_reminders(request):
    reminders = Reminders.objects.filter(reminder_sent=False, reminder_date__lte=datetime.today())
    for r in reminders:
        send_sms(r.report, 'Your tick bite report ID: ' + r.report.auth_id + ' and access code: ' + r.report.auth_code + '   Visit http://austick.auspollster.xyz if you have symptoms to report.')
        r.reminder_sent = True
        r.save()

    return HttpResponse("Reminders sent")
