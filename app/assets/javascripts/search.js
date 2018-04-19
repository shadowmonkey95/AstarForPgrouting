document.addEventListener("turbolinks:load", function(){
    var $input = $("[data-behavior='autocomplete']")

    var options = {
        getValue: "name",
        url: function (phrase) {
            return "/search.json?q=" + phrase;
        },
        categories: [
            {
                listLocation: "shops",
                header: "<strong>~~Shops~~</strong>",
            },
            {
                listLocation: "requests",
                header: "<strong>~~Requests~~</strong>",
            }

        ],
        list: {
            onChooseEvent: function() {
                var url = $input.getSelectedItemData().url
                $input.val("")
                Turbolinks.visit(url)
                // console.log(url)
            }
        }
    }
    $input.easyAutocomplete(options)
});