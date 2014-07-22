class Rescue extends Controller
  users: []
  
  constructor: (@$scope, @$element, @rescueService) ->
    do @declare_vars
    do @cache_DOM_elements
    do @set_triggers

    do @methods_encapsulation

  declare_vars: ->
    @$scope.data = {}

  cache_DOM_elements: ->
    @rescue_bt = @$element.find '#btRescue'
    @export_bt = @$element.find '#btExport'

  set_triggers: ->
    @rescue_bt.click @get_users
    @export_bt.click @generate_csv

    @$scope.$on 'all_users', @flatten
    @$scope.$on 'return_user', @push_user

  methods_encapsulation: ->
    @$scope.get_users = @get_users

  get_users: =>
    @$scope.$emit 'show_loader'

    self = @
    @actual_page = 1

    while @actual_page <= @$scope.data.total_pages
      
      data =
        user_id: @$scope.data.user_id
        session_id: @$scope.data.session_id
        site_id: @$scope.data.site_id
        page:  @actual_page
        limit: @$scope.data.limit
        sort_by: 'timestamp'
        sort_by_dir: 'DESC'

      promise = @rescueService.get_users data
      promise.then ((response) =>
        index = 0

        for user in response.data[0].response.site_user_analytics
          if index < ( response.data[0].response.site_user_analytics.length - 1 )
            @get_user_details user
            index++
          else
            @get_user_details user, true
      ), ( ->
        alert "Error on page #{self.actual_page}"
      )

      self.actual_page++

  get_user_details: (user, is_last) =>
    data =
      user_id: @$scope.data.user_id
      session_id: @$scope.data.session_id
      site_id: @$scope.data.site_id
      site_user_id: user.UID


    promise = @rescueService.get_user_details data
    promise.then ((response) =>
      extra_fields = angular.fromJson response.data[0].response.site_user.extra_fields
      user['first_name'] = extra_fields['first-name']
      user['last_name'] = extra_fields['last-name']

      @$scope.$broadcast 'return_user', user

      if is_last
        @$scope.$emit 'hide_loader'
        @$scope.$emit 'all_users'
    ), ( ->
      alert "Error on user #{UID}"
    )

  push_user: (event, user) =>
    @users.push user

  flatten: =>
    @users = _.flatten @users
    @$scope.users = @users

  generate_csv: =>
    content = [
      [
        "ID"
        "Email"
        "Fname"
        "Lname"
      ]
    ]

    for user in @users
      user_array = []

      user_array[0] = user.UID
      user_array[1] = user.email
      user_array[2] = user.first_name
      user_array[3] = user.last_name

      content.push user_array

    finalVal = ""
    i = 0

    while i < content.length
      value = content[i]
      j = 0

      while j < value.length
        innerValue = (if value[j] is null then "" else value[j].toString())
        result = innerValue.replace(/"/g, "\"\"")
        result = "\"" + result + "\""  if result.search(/("|,|\n)/g) >= 0
        finalVal += ","  if j > 0
        finalVal += result
        j++
      finalVal += "\n"
      i++
    
    window.open "data:text/csv;charset=utf-8," + encodeURIComponent(finalVal)