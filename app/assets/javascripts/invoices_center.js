$(document).ready(function()
{
    // debugger;
    // open invoice center on click
    $("#open_invoice").click(function()
    {
        $("#invoiceContainer").fadeToggle(300);
        $("#invoice_count").fadeOut("fast");
        return false;
    });

    // hide invoice center on click
    $(document).click(function()
    {
        $("#invoiceContainer").hide();
    });


    $("#invoiceContainer").click(function()
    {
        return false;
    });

    (function() {
        App.invoices = App.cable.subscriptions.create({
                channel: 'invoicesChannel'
            },
            {
                connected: function() {},
                disconnected: function() {},
                received: function(data) {

                    $('#invoiceList').prepend('' + data.invoice);
                    $('#invoiceList li').click(function(){
                        window.location.href = $(this).find('a').first().attr('href');
                    });

                    return this.update_counter(data.counter);
                },
                update_counter: function(counter) {
                    var $counter, val;
                    $counter = $('#invoice-counter');
                    val = parseInt($counter.text());
                    val++;
                    return $counter.css({
                    }).text(val)
                        .css({
                            top: '-10px'
                        })
                }
            });
    }).call(this);
});