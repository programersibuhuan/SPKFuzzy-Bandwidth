<div class="container">
	
	<div class="row">
		<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
			<?php include('form-network.php'); ?>
		</div>
		<div class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
			<table class="table table-hover table-condensed table-striped table-bordered">
				<thead>
					<tr>
						<th>No.</th>
						<th>Area</th>
						<th>Jurusan</th>
						<th>Titik</th>
						<th>B</th>
						<th>CMT</th>
						<th>CK</th>
						
						<th>Aksi</th>
					</tr>
				</thead>
				<?php include('list-network.php'); 
					show_fuzzy('all');
					//rule_fuzzy();
				?>
			</table>
		</div>
	</div>

</div>
