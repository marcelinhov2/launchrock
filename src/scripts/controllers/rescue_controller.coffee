class Rescue extends Controller
  users: []
  total_pages: 1

  constructor: (@$scope, @$element, @rescueService) ->
    do @declare_vars
    do @cache_DOM_elements
    do @set_triggers

  declare_vars: ->
    @$scope.data = {}

  cache_DOM_elements: ->
    @rescue_bt = @$element.find '#btRescue'

  set_triggers: ->
    @rescue_bt.click @get_users
    @$scope.$on 'all_users', @flatten
    @$scope.$on 'return_user', @push_user

  get_users: =>
    self = @
    @actual_page = 1

    while @actual_page <= @total_pages
      
      data =
        user_id: '195BNZBC'
        session_id:  'dc190096209f31e14018ba540682f1ed_AJKoAzWPad_1406043168'
        site_id: '13C7JTYE'
        page:  @actual_page
        limit: 1
        sort_by: 'timestamp'
        sort_by_dir: 'DESC'

      @rescueService.get_users data
        .success (data) =>
          index = 0

          for user in data[0].response.site_user_analytics
            if index < ( data[0].response.site_user_analytics.length - 1 )
              @get_user_details user
              index++
            else
              @get_user_details user, true

        .error =>
          console.log "Error on page #{self.actual_page}"

      self.actual_page++

  get_user_details: (user, is_last) =>
    data =
      user_id: '195BNZBC'
      session_id: 'dc190096209f31e14018ba540682f1ed_AJKoAzWPad_1406043168'
      site_id: '13C7JTYE'
      site_user_id: user.UID

    @rescueService.get_user_details data
      .success (extra_fields) =>
        extra_fields = angular.fromJson extra_fields[0].response.site_user.extra_fields
        user['first_name'] = extra_fields['first-name']
        user['last_name'] = extra_fields['last-name']

        @$scope.$broadcast 'return_user', user

        if is_last
          @$scope.$emit 'all_users'

      .error =>
        console.log "Error on user #{UID}"

  push_user: (event, user) =>
    @users.push user

  flatten: =>
    @users = _.flatten @users
    @$scope.users = @users