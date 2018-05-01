App.invoices = App.cable.subscriptions.create "InvoicesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    this.update_counter(data.counter)


  update_counter: (counter) ->
    $counter = $('#invoice-counter')
    val = parseInt $counter.text()
    val++
    $counter
      .text(val)
      .css({top: '-10px'})
