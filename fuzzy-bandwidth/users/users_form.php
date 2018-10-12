<?php 
	$id= isset($_GET['id']) ? $_GET['id'] : '';
	if(!empty($id) || isset($id)){
	
		$sqlnet="select * from `{nama_tabel}` where id='$id'";
		$hasil=mysql_query($sqlnet)or die('Query {nama_tabel} Error:'.mysql_error());
		while($rows=mysql_fetch_array($hasil)){
			{fields_tabel1}${name_field_table}=$rows['{name_field_table}']; 
			{/fields_tabel1}
                        
			
		}
		
	} {php_close} 
<form action="{nama_tabel}_proses.php" method="POST" role="form">
				<legend>Form {nama_tabel}</legend>
				<input type="hidden" name="form" value="{nama_tabel}">
				<input type="hidden" name="id" value="{php_open} echo (!empty($id)?$id:''); {php_close}">
				{fields_tabel2}
				<div class="form-group">
					<label for="{name_field_table}">{judul_field}</label>
					<input name="{name_field_table}" type="text" class="form-control" id="{name_field_table}" required placeholder="Masukkan {name_field_table}" value="{php_open} echo (!empty(${name_field_table})?${name_field_table}:''); {php_close}">
				</div>{/fields_tabel2}
				<button name="{php_open} echo !empty($id)?'save':'submit'; {php_close}" type="submit" class="btn btn-primary">Submit</button>
				<a href="{nama_tabel}.php" class="btn btn-warning">Batal</a>
	
</form>