module MetraTracker

  METRA_ENDPOINT = "http://metrarail.com/content/metra/en/home/jcr:content/trainTracker.get_train_data.json?"

  UNIMPORTANT_KEYS = ["trip_id", "status", "scheduled_dpt_time_note",
                      "selected", "scheduled_arv_time_note", "hasData",
                      "shouldHaveData", "isRed", "bikesText"]

  OUTPUT_HASH = {"train_num" => "Train number: ",
                 "scheduled_dpt_time" => " is scheduled to depart at: ",
                 "scheduled_arv_time" => " and is scheduled to arrive at: "}

  # These two are not used currently

  IMPORTANT_KEYS = ["train_num", "scheduled_dpt_time", "estimated_dpt_time",
                    "scheduled_arv_time", "estimated_arv_time",
                    "schDepartInTheAM", "schArriveInTheAM", "estDepartInTheAM",
                    "estArriveInTheAM", "notDeparted", "hasDelay"]


  TIME_KEYS = ["scheduled_dpt_time", "estimated_dpt_time",
               "scheduled_arv_time", "estimated_arv_time",
               "schDepartInTheAM", "schArriveInTheAM", "estDepartInTheAM",
               "estArriveInTheAM"]

end
