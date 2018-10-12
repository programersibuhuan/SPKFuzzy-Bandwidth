<?php 
include('../functions.php');
require('../koneksi.php');
include('../header.php');


?>


<?php
if(isset($_POST['submit'])){
	$form=isset($_POST['form']) ? $_POST['form'] : '';
		switch ($form) {
			case 'user':
					$id= isset($_POST['id']) ? clean(htmlspecialchars($_POST['id'])) : '';
					{fields_tabel3}${name_field_table}=isset($_POST['{name_field_table}']) ? clean(htmlspecialchars($_POST['{name_field_table}'])) : '';
					{/fields_tabel3}
					$sql="insert into {nama_tabel} ({fields_tabel6}{name_field_table},{/fields_tabel6}) values ({fields_tabel7}'".${name_field_table}."',{/fields_tabel7})";
						// echo $sql;
						$insert=mysql_query($sql)or die('Insert Data {nama_tabel} Error:'.mysql_error());
						// $numrows=mysql_num_rows($insert);
						if($insert>0){
							// echo $sql;
							alert('success','insert','{nama_tabel}.php');
							
						}else{
							alert('danger','insert','{nama_tabel}.php');
						}
				
			break;
		}
}elseif(!isset($_POST['submit'])){
	$form=isset($_GET['form']) ? $_GET['form'] : '';
	switch ($form) {
		case '{nama_tabel}':
			$a= isset($_GET['a']) ? $_GET['a'] : '';
			$id= isset($_GET['id']) ? $_GET['id'] : '';
				switch ($a) {
				case 'edit':
					include('{nama_tabel}_content.php');
					# code...
					break;
				case 'delete':
					
					delete('{nama_tabel}','id',$id);
					break;
				
				}
			break;
		default:
		# code...
		break;
	}
}
if(isset($_POST['save'])){
	$form= isset($_POST['form']) ? $_POST['form'] : '';
	switch ($form) {
		case '{nama_tabel}':
			$id= isset($_POST['id']) ? clean(htmlspecialchars($_POST['id'])) : '';
			{fields_tabel4}${name_field_table}=isset($_POST['{name_field_table}']) ? clean(htmlspecialchars($_POST['{name_field_table}'])) : '';
				{/fields_tabel4}
			if(isset($id)):
				$sql="update {nama_tabel} set {fields_tabel5}{name_field_table}='".${name_field_table}."',{/fields_tabel5} where id=".$id;
					$update=mysql_query($sql)or die('Update Data {nama_tabel} Error:'.mysql_error());
						if($update==true){
							// echo $sql;
							alert('success','update','{nama_tabel}.php');
						}else{
							alert('danger','update','{nama_tabel}.php');
						}
					endif;
			break;
	}
}
function delete($table=null,$field=null,$id=null){
	$table=isset($table) ? $table : '';
	$field=isset($field) ? $field : '';
	$id=isset($id) ? $id : '';
	if(isset($id)):
		$sqldelete="delete from `".$table."` where ".$field."=".$id;
		
		$hasil=mysql_query($sqldelete)or die("SQL Delete {nama_tabel} ERROR: ".$sqldelete."-->".mysql_error());
		if($hasil==true){
			alert('success','delete',$table.".php");
		}
	endif;
}


include('../footer.php');
?>
