
$(document).ready(function() {

  $(".buynow").click(function() {
    var product_id = this.id.split('-')[1]
    var data = {id: product_id, quantity: $('#quantity-'+product_id)[0].value}
    $.post('/add-to-cart',data, function(result,status) {
      console.log(result.data)
      if (result.err) return alert(result.data);

      $('.items-count')[0].innerHTML = Object.keys(result.data).length;

      alert("Thêm thành hàng vào giỏ thành công");

    });
  });

  $("#ckbtn").click(function() {
    console.log('Click')
  });
});
