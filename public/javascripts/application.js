// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function ShowLoading() {
    Element.show("loading")
};

function HideLoading() {
    Element.hide("loading")
};

Ajax.Responders.register({onCreate: ShowLoading, onComplete: HideLoading});

function blinddown(elem) {
    Effect.BlindDown(elem, { duration: 0.2 });
}

function blindup(elem) {
    Effect.BlindUp(elem, { duration: 0.2 });
}

function slide(elem) {
    if ($(elem).style.display == 'none')
      blinddown(elem);
    else
      blindup(elem);
}



document.observe("dom:loaded", function() {
  $$('a.fast_link').each(function(fast_link){
    Event.observe(fast_link, 'click', function(event) {
      var container = $(fast_link.readAttribute('container_id'));
      if (!('fastlink_data' in container)) {
          container.fastlink_data = [];
      }
      container.fastlink_data.push(this.innerHTML.strip());
      container.innerHTML = container.fastlink_data.uniq().join(', ');
    });
  });


  $$('.printable_links').each(function(print_control) {
    Event.observe(print_control, 'click', function(event) {
      if (event.element().hasClassName('printable_links')) {
        print_control.getElementsBySelector('ul a')[0].click();
      }
    });
    print_control.getElementsBySelector('div.open_list').each(function(list_control) {
      var list = print_control.getElementsBySelector('ul')[0];
      Event.observe(list_control, 'click', function(event) {
        list.toggle();
        event.stop();
      });
      print_control.getElementsBySelector('a').each(function(el){
        Event.observe(el, 'click', function(event){ console.log('link clicked'); list.hide();});
      });
    });

  });
});

function setAddressVisibility(sel) {
    if (sel.options[sel.selectedIndex].value == 'delivery') {
        document.getElementById('local_address').style.display = 'block';
    } else {
        document.getElementById('local_address').style.display = 'none';
    }
}



