<?php
/*
	Author: Peter Liscovius
*/

if (!defined('IN_FS')) {
	die('Do not access this file directly.');
}

if (!$user->perms('view_reports')) {
	Flyspray::show_error(28);
}


if (!$user->can_view_project($proj->id)) {
	$proj = new Project(0);
}



// Get the visibility state of all columns
$visible = explode(' ', trim($proj->id ? $proj->prefs['visible_columns'] : $fs->prefs['visible_columns']));
if (!is_array($visible) || !count($visible) || !$visible[0]) {
	$visible = array('id');
}

// Remove columns the user is not allowed to see
if (in_array('estimated_effort', $visible) && !$user->perms('view_estimated_effort')) {
	unset($visible[array_search('estimated_effort', $visible)]);
}
if (in_array('effort', $visible) && !$user->perms('view_current_effort_done')) {
	unset($visible[array_search('effort', $visible)]);
}


if( "mysql"==substr($db->dbtype, 0, 5) ){
	$GCONCATS='GROUP_CONCAT(';
	$GCONCATE=')';
} elseif( 'postgres'==substr($db->dbtype,0,8)){
	$GCONCATS='array_to_string(array_agg(';
	$GCONCATE='))';
} else{
	die($db->dbtype);
}
# Limited to 3 Levels, extend and in gantt.tpl for more if you really have deeper nested tasks.
$result=$db->Query('SELECT
	t1.task_id AS t1id,t1.project_id AS t1project,t1.task_type AS t1tasktype, t1.is_closed AS t1closed,
	t1.item_summary AS t1summary, t1.item_status AS t1status, t1.product_category AS t1category,
	t1.task_priority AS t1priority, t1.task_severity AS t1severity, t1.percent_complete AS t1percent_complete, t1.supertask_id AS t1parent,
	t1.date_opened AS t1dateopened, t1.opened_by AS t1openedby, t1.due_date AS t1duedate,
	t1.last_edited_time AS t1lastedit, t1.last_edited_by AS t1editedby,
	t1.date_closed AS t1dateclosed, t1.closed_by AS t1closedby, t1.product_version AS t1reportedin, t1.closedby_version AS t1dueversion,
	t1.mark_private AS t1private, t1.list_order AS t1order, t1.estimated_effort AS t1estimatedeffort,
	t1.operating_system AS t1os,
	t1.detailed_desc AS t1detailed_desc,
	COUNT(DISTINCT t1v.user_id) AS t1votes,
	COUNT(DISTINCT t1c.comment_id) AS t1comments,
	COUNT(t1e.task_id) AS t1effort,
	COUNT(DISTINCT t1a.attachment_id) AS t1attachments,

	t2.task_id AS t2id,t2.project_id AS t2project,t2.task_type AS t2tasktype, t2.is_closed AS t2closed,
	t2.item_summary AS t2summary, t2.item_status AS t2status, t2.product_category AS t2category,
	t2.task_priority AS t2priority, t2.task_severity AS t2severity, t2.percent_complete AS t2percent_complete, t2.supertask_id AS t2parent,
	t2.date_opened AS t2dateopened, t2.opened_by AS t2openedby, t2.due_date AS t2duedate,
	t2.last_edited_time AS t2lastedit, t2.last_edited_by AS t2editedby,
	t2.date_closed AS t2dateclosed, t2.closed_by AS t2closedby,
	t2.product_version AS t2reportedin, t2.closedby_version AS t2dueversion,
	t2.mark_private AS t2private, t2.list_order AS t2order, t2.estimated_effort AS t2estimatedeffort,
	t2.operating_system AS t2os,
	t2.detailed_desc AS t2detailed_desc,
	COUNT(DISTINCT t2v.user_id) AS t2votes,
	COUNT(DISTINCT t2c.comment_id) AS t2comments,
	COUNT(t2e.task_id) AS t2effort,
	COUNT(DISTINCT t2a.attachment_id) AS t2attachments,
	
	t3.task_id AS t3id,t3.project_id AS t3project,t3.task_type AS t3tasktype, t3.is_closed AS t3closed,
	t3.item_summary AS t3summary, t3.item_status AS t3status, t3.product_category AS t3category,
	t3.task_priority AS t3priority, t3.task_severity AS t3severity, t3.percent_complete AS t3percent_complete, t3.supertask_id AS t3parent,
	t3.date_opened AS t3dateopened, t3.opened_by AS t3openedby, t3.due_date AS t3duedate,
	t3.last_edited_time AS t3lastedit, t3.last_edited_by AS t3editedby,
	t3.date_closed AS t3dateclosed, t3.closed_by AS t3closedby,
	t3.product_version AS t3reportedin, t3.closedby_version AS t3dueversion,
	t3.mark_private AS t3private, t3.list_order AS t3order, t3.estimated_effort AS t3estimatedeffort,
	t3.operating_system AS t3os,
	t3.detailed_desc AS t3detailed_desc,
	COUNT(DISTINCT t3v.user_id) AS t3votes,
	COUNT(DISTINCT t3c.comment_id) AS t3comments,
	COUNT(t3e.task_id) AS t3effort,
	COUNT(DISTINCT t3a.attachment_id) AS t3attachments,

	'.$GCONCATS.'t1d.dep_task_id'.$GCONCATE.' AS t1dep,
	'.$GCONCATS.'t2d.dep_task_id'.$GCONCATE.' AS t2dep,
	'.$GCONCATS.'t3d.dep_task_id'.$GCONCATE.' AS t3dep,

	'.$GCONCATS.'t1r.related_task'.$GCONCATE.' AS t1rel,
	'.$GCONCATS.'t2r.related_task'.$GCONCATE.' AS t2rel,
	'.$GCONCATS.'t3r.related_task'.$GCONCATE.' AS t3rel,

	'.$GCONCATS.'DISTINCT t1ass.user_id'.$GCONCATE.' AS t1assignedto,
	'.$GCONCATS.'DISTINCT t2ass.user_id'.$GCONCATE.' AS t2assignedto,
	'.$GCONCATS.'DISTINCT t3ass.user_id'.$GCONCATE.' AS t3assignedto
	
	FROM {tasks} t1
	LEFT JOIN {tasks} t2 ON t1.task_id=t2.supertask_id
	LEFT JOIN {tasks} t3 ON t2.task_id=t3.supertask_id
	LEFT JOIN {assigned} t1ass ON t1ass.task_id=t1.task_id
	LEFT JOIN {assigned} t2ass ON t2ass.task_id=t2.task_id
	LEFT JOIN {assigned} t3ass ON t3ass.task_id=t3.task_id
	LEFT JOIN {votes} t1v ON t1v.task_id=t1.task_id
	LEFT JOIN {votes} t2v ON t2v.task_id=t2.task_id
	LEFT JOIN {votes} t3v ON t3v.task_id=t3.task_id
	LEFT JOIN {comments} t1c ON t1c.task_id=t1.task_id
	LEFT JOIN {comments} t2c ON t2c.task_id=t2.task_id
	LEFT JOIN {comments} t3c ON t3c.task_id=t3.task_id
	LEFT JOIN {effort} t1e ON t1e.task_id=t1.task_id
	LEFT JOIN {effort} t2e ON t2e.task_id=t2.task_id
	LEFT JOIN {effort} t3e ON t3e.task_id=t3.task_id
	LEFT JOIN {dependencies} t1d ON t1d.task_id=t1.task_id
	LEFT JOIN {dependencies} t2d ON t2d.task_id=t2.task_id
	LEFT JOIN {dependencies} t3d ON t3d.task_id=t3.task_id
	LEFT JOIN {related} t1r ON t1r.this_task=t1.task_id
	LEFT JOIN {related} t2r ON t2r.this_task=t2.task_id
	LEFT JOIN {related} t3r ON t3r.this_task=t3.task_id
	LEFT JOIN {attachments} t1a ON t1a.task_id=t1.task_id
	LEFT JOIN {attachments} t2a ON t2a.task_id=t2.task_id
	LEFT JOIN {attachments} t3a ON t3a.task_id=t3.task_id
	WHERE t1.supertask_id=0 OR t1.supertask_id IS NULL
	GROUP BY t1.task_id, t2.task_id, t3.task_id
	ORDER BY
		t1.task_severity DESC, t1.task_id,
		t2.task_severity DESC, t2.task_id,
		t3.task_severity DESC, t3.task_id
	'
);

$tasks=array();
while ($t = $db->FetchRow($result)) {
	$tasks[]=$t;
}

#echo '<pre>';print_r($tasks);die();
$total=count($tasks);
$page->uses('tasks','total','visible');
$page->pushTpl('gantt.tpl');
