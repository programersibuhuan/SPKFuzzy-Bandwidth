<?php 
// require('koneksi.php');
$sql="select * from users";
$result=mysql_query($sql)or die('Maaf, Query users Salah:'.mysql_error());

function show_fuzzy($show){
	global $result;

	if($result==true){
		$i=1;
		while($row=mysql_fetch_array($result)):
			?>
				<tr>
					<td><?php echo $i;?></td>
					<td><?php echo $row['id'] {php_close}</td>
					{fields_tabel2}<td>{php_open} echo $row['{name_field_table}'] {php_close}</td>
					{/fields_tabel2}
					
						
					
					
				{php_open}
					switch ($show) {
						case 'all':
							{php_close}
							<td><div class="btn-group">
								<a href="{nama_tabel}_proses.php?form={nama_tabel}&a=edit&id={php_open} echo $row['id'] {php_close}" class="btn btn-xs btn-success">Edit</a>
								<a href="{nama_tabel}_proses.php?form={nama_tabel}&a=delete&id={php_open} echo $row['id'] {php_close}" class="btn btn-xs btn-danger">Delete</a>
							</div></td>
							{php_open}
							
							break;
						case 'no-edit':
							{php_close}
								<td></td>
							{php_open}
						break;
						
					}
				{php_close}
				</tr>
			{php_open}
			$i++;	
		endwhile;
	}
}


?>

