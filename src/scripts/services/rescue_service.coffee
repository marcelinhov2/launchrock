class Rescue extends Service
  constructor: (@$q, @$http) ->

  get_users: (data) ->
    @$http(
      method: "POST"
      url: "http://platform.launchrock.com/v1/getSiteUserInsights"
      data: $.param data
      headers:
        "Content-Type": "application/x-www-form-urlencoded"
    )

  get_user_details: (data) ->
    @$http(
      method: "POST"
      url: "http://platform.launchrock.com/v1/getSiteUserExtraData"
      data: $.param data
      headers:
        "Content-Type": "application/x-www-form-urlencoded"
    )