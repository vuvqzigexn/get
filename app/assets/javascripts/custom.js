$(document).on('turbolinks:load', function() {

  function notify(title,message) {
    $('#modal-title')[0].innerHTML = title;
    $('#modal-body')[0].innerHTML = message;
    $('#myModal').modal({show: 'true'});
  }

  $(".buynow").click(function() {
    var product_id = this.id.split('-')[1]
    var order = {id: product_id, quantity: parseInt($('#quantity-'+product_id)[0].value)}
    $.ajax({
      url: '/add-to-cart',
      type: 'POST',
      beforeSend: $.rails.CSRFProtection,
      data: order,
      success:function(data){
        if (data.err) return notify('Thông báo',data.result);
        $('.items-count')[0].innerHTML = Object.keys(data.result).length;
        notify('Thông báo',"Sản phẩm đã được thêm vào giỏ hàng!");
      }
    });
  });

  function calculatePrice() {
    var items = $(".item-card-quantity");
    var totalPrice =0
    for (i = 0; i < items.length; i++) {
      totalPrice += items[i].value * $('#price'+items[i].dataset.id).val();
    }
    if (0 == totalPrice) {
      $('#ckbtn').remove();
      $('.cart-items').append('<h3>Giỏ trống</h3>')
    }
    $('.totalFormat')[0].innerHTML = '$' + totalPrice / 100.0 ;
  }
  function updateQuantity(id, quantity) {
    $.ajax({
      url: '/update-item-quantity',
      type: 'PUT',
      beforeSend: $.rails.CSRFProtection,
      data: {id: id, quantity: quantity},
      success: function(data) {
        if (data.error) return notify('Thông báo',data.result);
      }
    });
  }

  $(".item-card-quantity").on('click or change', function() {
    calculatePrice();
    updateQuantity(this.dataset.id, this.value);
  });


  $('.remove-item').click(function() {
    var id = this.id.replace('rm','');
    $.ajax({
      url: '/remove-item',
      type: 'PUT',
      beforeSend: $.rails.CSRFProtection,
      data: {id: id },
      success: function(data) {
        if (data.error) return;
        $('.items-count')[0].innerHTML = $(".item-card-quantity").length;
        $('#'+id).remove();
        calculatePrice();
        notify('Thông báo','Đã xóa sản phẩm khỏi giỏ');
      }
    });
  });

  $('.changes-status').on('change', function() {
    var id = this.id.replace('status_','');
    $.ajax({
      url: '/admin/change-status',
      type: 'PUT',
      beforeSend: $.rails.CSRFProtection,
      data: {id: id, status_id: this.value},
      success: function(data) {
        if (data.error) return notify('Thông báo',data.result); ;
        // console.log('Changed status!')
      }
    });
  })

});
