# CovidTracker

A Covid Tracking app for England, based on information provided by Public Health England.

## Apple won't approve my Covid 19 app. They're probably right.

It started as it always starts. With an idea. It seemed really difficult to work out where in the UK was worst hit by the virus. This was before the government introduced the 3 tier system (which is working flawlessly). If you wanted to travel to a place, how could you know if the area was under local restrictions? How high was the current infection rate in that area?

To work out the trend information you had to go to a government [website](https://www.gov.uk/government/publications/national-covid-19-surveillance-reports), download some excel sheets. Then you would find your local authority and work out the infection rate from there, select the correct sheet in the workbook, understand how the data was presented (as cumulative since 29th of July) then work out the trends from the raw data in the sheet.

When you wanted to then see any local lock downs in that area, you would go to a second [webpage](https://www.gov.uk/guidance/local-covid-alert-levels-what-you-need-to-know), search for the local authority you were interested in and find its subpage from there.

This all seemed like too much, but I had the data, a degree in social sciences and a copy of Xcode so I set to work. Toggl tells me that about 3 hours later I had the first draft of my app. Covid Track. I submitted it to apple for test flight testing. 

It entered beta review and... failed.

Apple had some questions. I answered then as well as I could, provided information about the data source and the licence I was using the data under, and resubmitted.

It entered beta review and... failed.

Annoyingly the reason they gave made sense.

_"We found in our review that your app provides services or requires sensitive user information related to the COVID-19 pandemic. Since the COVID-19 pandemic is a public health crisis, services and information related to it are considered to be part of the healthcare industry. In addition, the seller and company names associated with your app are not from a recognized institution, such as a governmental entity, hospital, insurance company, non-governmental organization, or university."_

I considered making an appeal to this. While it is true that I am not one of the organisations listed, I have worked on medical apps in the past and do work closely with a medical company. Perhaps I could get that company to take a look over the app. Perhaps that would be enough.

A few days ago I visited a friend, we were talking about the virus. He started telling me he had doubts about what we were being told by the government. About how there might be things going on that we are not being told about. He had been reading Facebook.

I told him I always doubted conspiracy theories. I had spent more than a decade working in the defence. Both for the government and in industry. I told him that nothing I had seen in that time made me think they could keep an international conspiracy secret. He made a hmmm noise and we moved on.

The important point here is that people do not trust the information they are given by official sources. There are many reasons for this. Some are valid, some are not. One reason is that the official information is often contradicted by other information. Information, that is far more exciting. Information that does a better job of grabbing the attention and lighting up the amygdala.

People need the information from government and related sources to be of good quality. It needs to be true, free of error and bias (as far as possible). If it is not, then it will feed disinformation.

I do not believe my little app would have contributed to this, but I can see the potential for it in general. I am disappointed the app will not go any further. I think it could have helped people. But I also believe that Apple is performing a public service here. It is helping make sure that people are not being given people bad information in a time of crisis.

Good for you Apple! Please never reject me again.

I am making the code base for the app open source. [You can find it on GitHub here](https://github.com/stropdale/CovidTracker). Please make what use of it you please.

If you would like it on your Mac desktop, you can [download a notarised copy here](https://github.com/stropdale/CovidTracker/blob/main/CovidTraker.zip). Please be warned, the data only goes up to October the 2nd. My intention was for it to update itself, but I didn't get that far. Also, for some reason the England government has stopped updating the data sets since they moved over to the Tier based system. There's a lesson in that too.
