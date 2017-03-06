$(document).on('turbolinks:load', function() {
  $(".buynow").click(function() {
    var product_id = this.id.split('-')[1]
    var data = {id: product_id, quantity: parseInt($('#quantity-'+product_id)[0].value)}
    $.post('/add-to-cart',data, function(result,status) {
      if (result.err) return
        // alert(result.data);

      $('.items-count')[0].innerHTML = Object.keys(result.data).length;

      alert("Sản phẩm của bạn đã được thêm vào giỏ hàng!");

    });
  });
  $('.deletebtn').on('click',function() {
    return confirm("Are you sure ?");
  });

  // $("#ckbtn").click(function() {
  // });
});
