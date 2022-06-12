<script src="https://kit.fontawesome.com/1f80141c3d.js" crossorigin="anonymous"></script>
{script src="js/addons/altteam_pro_reviews/jquery.easypiechart.min.js"}

<script type="text/javascript">
	(function (_, $) {
		$('.chart').easyPieChart({
			easing: 'easeOutBounce',
			onStep: function(from, to, percent) {
				$(this.el).find('.percent').text(Math.round(percent));
			}
		});
	})(Tygh, Tygh.$);
</script>