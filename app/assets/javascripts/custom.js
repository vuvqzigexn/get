$(document).on('turbolinks:load', function() {
  var order = {}
  $(".buynow").click(function() {
    var product_id = this.id.split('-')[1]
    var order = {id: product_id, quantity: parseInt($('#quantity-'+product_id)[0].value)}
    $.post('/add-to-cart',order, function(result,status) {
      if (result.err) return
        // alert(result.data);
      $('.items-count')[0].innerHTML = Object.keys(result.data).length;
      alert("Sản phẩm của bạn đã được thêm vào giỏ hàng!");
    });
  });

  function calculatePrice() {
    var items = $(".item-card-quantity");
    var totalPrice =0
    for (i = 0; i < items.length; i++) {
      totalPrice += items[i].value * $('#price'+items[i].dataset.id).val();
    }
    $('.totalFormat')[0].innerHTML = '$' + totalPrice / 100.0 ;
  }
  function updateQuantity(id, quantity) {
    $.ajax({
      url: '/update-item-quantity',
      type: 'PUT',
      data: {id: id, quantity: quantity },
      success: function(data) {
        if (data.error) return;
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
      data: {id: id },
      success: function(data) {
        if (data.error) return;
        $('.items-count')[0].innerHTML = $(".item-card-quantity").length;
        $('#'+id).remove();
        setTimeout(function() {
          calculatePrice();
          alert('Xóa mất rồi');
        },500);
      }
    });
  });

  $('.changes-status').on('change', function() {
    var id = this.id.replace('status_','');
    $.ajax({
      url: '/admin/change-status',
      type: 'PUT',
      data: {id: id, status_id: this.value},
      success: function(data) {
        if (data.error) return;
        // console.log('Changed status!')
      }
    });
  })

});
