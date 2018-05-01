# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class Activities
  constructor: ->
    @activities = $("[data-behavior='activities']")
    @setup() if @activities.length > 0

  setup: ->
    $("[data-behavior='activities-link']").on "click", @handleClick
    $.ajax(
      url: "/activities.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleClick: (e) ->
    $.ajax(
      url: "/activities/mark_as_read"
      dataType: "JSON"
      method: "POST"
      success: ->
        $("[data-behavior='unread-count']").text(0)
    )

  handleSuccess: (data) =>
    console.log(data)
    items = $.map data, (activity) ->
      "<a class='dropdown-item' href='#{activity.url}'>Found a shipper"
    $("[data-behavior='unread-count']").text(items.length)
    $("[data-behavior='activity-items']").html(items)
    setTimeout @setup, 2000

jQuery ->
  new Activities
#class Activities
#  constructor: ->
#    @activities = $("[data-behavior='activities']")
#    @setup() if @activities.length > 0
#
#  setup: ->
#    $("[data-behavior='activities-link']").on "click", @handleClick
#    $.ajax(
#      url: "/activities.json"
#      dataType: "JSON"
#      method: "GET"
#      success: @handleSuccess
#    )
#
#  handleClick: (e) ->
#    $.ajax(
#      url: "/activities/mark_as_read"
#      dataType: "JSON"
#      method: "POST"
#      success: ->
#        $("[data-behavior='unread-count']").text(0)
#    )
#
#  handleSuccess: (data) =>
#    console.log(data)
#    items = $.map data, (activity) ->
#      "<a class='dropdown-item' href='#{activity.url}'>Found a shipper"
#    $("[data-behavior='unread-count']").text(items.length)
#    $("[data-behavior='activity-items']").html(items)
#
#jQuery ->
#  new Activities
#@ActivityPoller =
#  poll: ->
#    setTimeout @request, 2000
#
#  request: ->
#    console.log("Polling")
#    $("[data-behavior='activities-link']").on "click", @handleClick
#    $.ajax(
#      url: "/activities.json"
#      dataType: "JSON"
#      method: "GET"
#      success: @handleSuccess
#    )
#
#  handleSuccess: (data) =>
#    console.log(data)
#    items = $.map data, (activity) ->
#      "<a class='dropdown-item' href='#{activity.url}'>Found a shipper"
#    $("[data-behavior='unread-count']").text(items.length)
#    $("[data-behavior='activity-items']").html(items)
#
#
#
#jQuery ->
#  if $("[data-behavior='activities']").length > 0
#    ActivityPoller.poll()
#    ActivityPoller.handleSuccess()