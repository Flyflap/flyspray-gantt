<?php

if (!defined('IN_FS')) {
	die('Do not access this file directly.');
}

if (!$user->can_view_project($proj->id)) {
	$proj = new Project(0);
}

# Get the visibility state of all columns
$visible = explode(' ', trim($proj->id ? $proj->prefs['visible_columns'] : $fs->prefs['visible_columns']));
if (!is_array($visible) || !count($visible) || !$visible[0]) {
	$visible = array('id');
}

# Remove columns the user is not allowed to see
if (in_array('estimated_effort', $visible) && !$user->perms('view_estimated_effort')) {
	unset($visible[array_search('estimated_effort', $visible)]);
}
if (in_array('effort', $visible) && !$user->perms('view_current_effort_done')) {
	unset($visible[array_search('effort', $visible)]);
}

# Limited to 3 Levels, extend here and in tree.tpl for more if you really have deeper nested tasks.
$result=$db->Query('SELECT
        t1.task_id AS t1id,t1.project_id AS t1project_id,t1.task_type AS t1tasktype, t1.is_closed AS t1closed,
        t1.item_summary AS t1summary, t1.item_status AS t1status, t1.product_category AS t1category,
        t1.task_priority AS t1priority, t1.task_severity AS t1severity, t1.percent_complete AS t1percent_complete, t1.supertask_id AS t1parent,
        t1.date_opened AS t1dateopened, t1.due_date AS t1duedate, t1.last_edited_time AS t1lastedit, t1.date_closed AS t1dateclosed,
        t1.mark_private AS t1private, t1.list_order AS t1order, t1.estimated_effort AS t1estimatedeffort,
        t1.detailed_desc AS t1detailed_desc,
        COUNT(t1v.task_id) AS t1votes,
        COUNT(t1c.task_id) AS t1comments,
        COUNT(t1e.task_id) AS t1effort,

        t2.task_id AS t2id,t2.project_id AS t2project_id,t2.task_type AS t2tasktype, t2.is_closed AS t2closed,
        t2.item_summary AS t2summary, t2.item_status AS t2status, t2.product_category AS t2category,
        t2.task_priority AS t2priority, t2.task_severity AS t2severity, t2.percent_complete AS t2percent_complete, t2.supertask_id AS t2parent,
        t2.date_opened AS t2dateopened, t2.due_date AS t2duedate, t2.last_edited_time AS t2lastedit, t2.date_closed AS t2dateclosed,
        t2.mark_private AS t2private, t2.list_order AS t2order, t2.estimated_effort AS t2estimatedeffort,
        t2.detailed_desc AS t2detailed_desc,
        COUNT(t2v.task_id) AS t2votes,
        COUNT(t2c.task_id) AS t2comments,
        COUNT(t2e.task_id) AS t2effort,

        t3.task_id AS t3id,t3.project_id AS t3project_id,t3.task_type AS t3tasktype, t3.is_closed AS t3closed,
        t3.item_summary AS t3summary, t3.item_status AS t3status, t3.product_category AS t3category,
        t3.task_priority AS t3priority, t3.task_severity AS t3severity, t3.percent_complete AS t3percent_complete, t3.supertask_id AS t3parent,
        t3.date_opened AS t3dateopened, t3.due_date AS t3duedate, t3.last_edited_time AS t3lastedit, t3.date_closed AS t3dateclosed,
        t3.mark_private AS t3private, t3.list_order AS t3order, t3.estimated_effort AS t3estimatedeffort,
        t3.detailed_desc AS t3detailed_desc,
        COUNT(t3v.task_id) AS t3votes,
        COUNT(t3c.task_id) AS t3comments,
        COUNT(t3e.task_id) AS t3effort

        FROM {tasks} t1
        LEFT JOIN {tasks} t2 ON t1.task_id=t2.supertask_id
        LEFT JOIN {tasks} t3 ON t2.task_id=t3.supertask_id
        LEFT JOIN {votes} t1v ON t1v.task_id=t1.task_id
        LEFT JOIN {votes} t2v ON t2v.task_id=t2.task_id
        LEFT JOIN {votes} t3v ON t3v.task_id=t3.task_id
        LEFT JOIN {comments} t1c ON t1c.task_id=t1.task_id
        LEFT JOIN {comments} t2c ON t2c.task_id=t2.task_id
        LEFT JOIN {comments} t3c ON t3c.task_id=t3.task_id
        LEFT JOIN {effort} t1e ON t1e.task_id=t1.task_id
        LEFT JOIN {effort} t2e ON t2e.task_id=t2.task_id
        LEFT JOIN {effort} t3e ON t3e.task_id=t3.task_id
        WHERE t1.supertask_id=0 OR t1.supertask_id IS NULL
        GROUP BY t1.task_id, t2.task_id, t3.task_id
        ORDER BY t1.task_id, t2.task_id, t3.task_id'
);

while ($t = $db->FetchRow($result)) {
	$tasks[]=$t;
}
#echo '<pre>';print_r($tasks[2]);die();
$total=count($tasks);
$page->uses('tasks','total','visible');
$page->pushTpl('tree.tpl');
