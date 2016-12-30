$(document).ready(function () {
// Animate opening post divs on home page
	posts = $(".unit-container");
	for (let i = 0; i < posts.length; i++) {
		$(".unit-container").eq(i).on ("click", function ()	{
			for (var j = 0; j < posts.length; j++) {
				$(".post-contents").eq(j).slideUp ("slow");
			}
			$(".post-contents").eq(i).slideDown ("slow");
		});
	}

// Disable login_name field if "use email" is checked
	$("#login-email-checkbox").on ("click", function ()	{
		if ($("#login-email-checkbox").prop("checked"))	{
			$("#login-name-input").attr("disabled", "true");
		}	else	{
			$("#login-name-input").removeAttr("disabled");
		}
	});

// Put cursor in first field of each modal
	for (let i = 0; i < $(".modal").length; i++) {
		$(".modal").eq(i).on ("shown.bs.modal", function () {
			$(".first-field").eq(i).focus ();
		});
	}
});
