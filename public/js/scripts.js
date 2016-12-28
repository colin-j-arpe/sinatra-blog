$(document).ready(function () {
	posts = $(".unit-container");
	for (let i = 0; i < posts.length; i++) {
		$(".unit-container").eq(i).on ("click", function ()	{
			for (var j = 0; j < posts.length; j++) {
				$(".post-contents").eq(j).slideUp ("slow");
			}
			$(".post-contents").eq(i).slideDown ("slow");
		});
	}

	$("#login-email-checkbox").on ("click", function ()	{
		if ($("#login-email-checkbox").prop("checked"))	{
			$("#login-name-input").attr("disabled", "true");
		}	else	{
			$("#login-name-input").removeAttr("disabled");
		}
	});
});

