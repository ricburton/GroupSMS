function remove_fields (link) {
	$(link).previous("input[type=hidden]").value = "1";
	$(link).up(".fields").hide();
}

//$(document).ready(function(){
//  $('#add_new_member').click(function(){
//     $('#user').clone().appendTo('body');
//     return false;
//  });
//});
//
//$(function(){
//  // Binds to the remove task link...
//  $('.remove_task').live('click', function(e){
//    e.preventDefault();
//    $(this).parents('.task').remove();
//  });
//
//  // Add task link, note that the content we're appending
//  // to the tasks list comes straight out of the data-partial
//  // attribute that we defined in the link itself.
//  $('.add_member').live('click', function(e){
//    e.preventDefault();
//    $('#users').append($(this).data('user'));
//  });
//});
//

//function add_fields(link, association, content) {
//  var new_id = new Date().getTime();
//  var regexp = new RegExp("new_" + association, "g")
//  $(link).up().insert({
//    before: content.replace(regexp, new_id)
//  });
//}