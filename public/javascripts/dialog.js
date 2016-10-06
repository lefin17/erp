var dialog = {
  hide: function() {
    new Effect.DropOut('dialog', {duration: 0.3});
    new Effect.Fade('overlay', {duration: 0.3});
    document.body.setStyle({overflow : 'visible'});
  },
  show: function() {
    document.body.setStyle({overflow : 'hidden'});
    new Effect.Appear('overlay', {duration: 0.2});
    new Effect.Appear('dialog', {duration: 0.2});
  },
  select: function(element,value_name,value_id) {
      $([element,'name'].join('_')).value = value_name;
      $([element,'id'].join('_')).value = value_id;
      this.hide();
  }
}

