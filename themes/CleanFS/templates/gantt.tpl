<?php require_once('permicons.tpl'); ?>
<style>
#content{position:relative;}
#tasklist_table {display:inline-block;}
#tasklist_table thead {max-width:50px;width:50px;overflow:hidden;text-overflow:hidden;}
#tasklist_table td, #tasklist_table th{width:50px;white-space:nowrap;overflow:hidden;max-width:50px;}
.gt{display:inline-block;width:4px;position:absolute;top:0;background-color:#0cf;border-radius:2px;}
.gt a{color:#000;}
.gt.super{width:150px;}
tr.closed {opacity:0.4;}
tr.closed a {text-decoration:line-through;}
#mycanvas{position:absolute;top:0;left:0;z-index:-1;}
</style>
<table id="tasklist_table">
<colgroup>
	<col class="caret" />
	<?php if (!$user->isAnon() && $proj->id !=0): ?><col class="toggle" /><?php endif; ?>
	<?php foreach ($visible as $col): ?>
        <col class="<?php echo $col; ?>" />
        <?php endforeach; ?>
	<col />
</colgroup>
<colgroup width="100%"><col /></colgroup>
<thead>
<tr>
<?php foreach ($visible as $col):
		if($col=='progress'): echo '<th style="width:50px;">'.Filters::noXSS(L($col)).'</th>';
		elseif($col=='comments'): echo '<th style="width:50px;" title="'.eL('comments').'"><i class="fa fa-comments"></i></th>';
		elseif($col=='dateopened'): echo '<th style="width:50px;" title="'.eL('opened').'"><i class="fa fa-calendar-o"></i></th>';
		elseif($col=='lastedit'): echo '<th style="width:50px;" title="'.eL('lastedit').'"><i class="fa fa-calendar-o"></i></th>';
		elseif($col=='duedate'): echo '<th style="width:50px;" title="'.eL('duedate').'"><i class="fa fa-calendar-o"></i></th>';
		elseif($col=='dateclosed'): echo '<th style="width:50px;" title="'.eL('dateclosed').'"><i class="fa fa-calendar-o"></i></th>';
		elseif($col=='private'): echo '<th style="width:50px;" title="'.eL('private').'"><i class="fa fa-lock"></i></th>';
		elseif($col=='votes'): echo '<th style="width:50px;" title="'.eL('votes').'"><i class="fa fa-star"></i></th>';
		elseif($col=='parent'): echo '<th style="width:50px;" title="'.eL('parent').'"><i class="fa fa-level-up fa-flip-horizontal"></i></th>';
		elseif($col=='effort'): echo '<th style="width:50px;" title="'.eL('effort').'"><i class="fa fa-clock-o"></i></th>';
		elseif($col=='status'): echo '<th style="width:50px;" title="'.eL('status').'"><i class="fa fa-circle"></i></th>';
		elseif($col=='estimatedeffort'): echo '<th style="width:50px;" title="'.eL('estimatedeffort').'"><i class="fa fa-clock-o"></i></th>';
		elseif($col=='attachments'): echo '<th style="width:50px;" title="'.eL('attachmentss').'"><i class="fa fa-paperclip"></i></th>';
		else: echo '<th style="max-width:30px;overflow:hidden;">'.Filters::noXSS(L($col)).'</th>';
		endif;
endforeach; ?>
	<th style="width:100%"></th>
</tr>
</thead>
<tbody>
<?php
# maybe rainbow generator with size:  count(*) ... GROUP BY supertask_id ...
$n=2;
$r=255;
$g=0;
$b=0;
for($i=0;$i<=$n;$i++){
	$bg[]='rgba('.$r.','.$g.','.$b.', 0.5)';
	$r-=64;
	$g+=64;
}
for($i=0;$i<=$n;$i++){
	$bg[]='rgba('.$r.','.$g.','.$b.', 0.5)';
	$g-=64;
	$b+=64;
}
for($i=0;$i<=$n;$i++){
	$bg[]='rgba('.$r.','.$g.','.$b.', 0.5)';
	$b-=64;
	$r+=64;
}
#$bg=array('','#ffc','#fcc', '#ccc','#fcf','#cff','#cfc','#ccf');
$bgi=0;
$r=0;
$lastsuper=-1;
$c=array(); # fuer canvas dependency lines
$due=array(); # fuer Anzeige Fertigstellungstermine

# We must loop at least one additional time for filtering closed and private status and layouting timeline.
# So lets collect row output in array first...
foreach ($tasks as $task_details):
	if($task_details['t3duedate']){
		#echo "\nt3 ".$task_details['t3id']." ".$task_details['t3duedate'];
	}
	if($task_details['t2duedate']){
		#echo "\nt2 ".$task_details['t2id']." ".$task_details['t2duedate'];
	}
	if($task_details['t1duedate']){
		#echo "\nt1 ".$task_details['t1id']." ".$task_details['t1duedate'];
	}


	if($task_details['t1id']==3){
		#print_r($task_details);
		#die();
	}

endforeach;

# reset $r
$r=0;
foreach ($tasks as $task_details):
	$r++;
	if($lastsuper!=$task_details['t1id']){
		$bgi++;
		$fl=1; # firstlevel 
		$sl=1; # secondlevel
	}
	if ($task_details['t3id']){ $l=3; }
	elseif ( $task_details['t2id']){ $l=2; }
	else { $l=1; }

	if ($fl==1 && ($l==2 || $l==3)): ?>
		<tr id="task<?php echo $task_details['t1id']; ?>" class="sev<?php echo Filters::noXSS($task_details['t1severity']); echo $task_details['t'.$l.'closed']==1 ? ' closed':''; ?>">
		<?php
		if( $task_details['t'.$l.'dep']!=''){
			$deps=explode(',', $task_details['t1dep']);
			foreach($deps as $dep){
				$c[]='{step: "1", tsrc:"t'.$dep.'", fsrc:"", ttgt:"t'.$task_details['t1id'].'", ftgt:""}';
			}
		}

		foreach ($visible as $col):
			if($col == 'progress'):
		?>
			<td style="border-top:1px solid #bbb;min-width:50px;" class="task_progress">
			<div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t1percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t1percent_complete']); ?>%"></div></div>
			</td>
			<?php elseif ($col=='id'): ?>
			<td style="<?php echo 'background-color:'.$bg[$bgi]; ?>"><?php echo $task_details['t1'.$col]; ?></td>
			<?php elseif ($col=='votes' || $col=='comments' || $col=='attachments' || $col=='parent' || $col=='private' || $col=='duedate' || $col=='dueversion' || $col=='dateclosed' || $col=='closedby' || $col=='editedby' || $col=='estimatedeffort' || $col=='effort'): ?>
			<td class="<?php echo $col; ?>" style="border-top:1px solid #bbb;"><?php echo ($task_details['t1'.$col] >0) ? $task_details['t1'.$col]:''; ?></td>
			<?php elseif ($col=='summary'): ?>
			<td style="border-top:1px solid #bbb;"><a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t1id'])); ?>"><?php echo Filters::noXSS($task_details['t1'.$col]); ?></a></td>
			<?php else: ?>
			<td class="<?php echo $col; ?>" style="border-top:1px solid #bbb;"><?php echo Filters::noXSS($task_details['t1'.$col]); ?></td>
			<?php endif; ?>
		<?php endforeach; ?>
		<td style="position:relative;border-top:1px solid #bbb;">
			<div class="gt super" id="t<?php echo $task_details['t1id']; ?>">
			<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t1id'])); ?>"><?php echo Filters::noXSS($task_details['t1summary']); ?></a>
			</div>
			<?php
			if ($task_details['t1duedate']):
				$due[]='{ tsrc:"t'.$task_details['t1id'].'", duetime:"'.$task_details['t1duedate'].'"}';		
			endif; 
			?>
		</td>
		<td id="desc_<?php echo $task_details['t1id']; ?>" class="descbox"><b><?php echo L('taskdescription'); ?></b>
		<?php echo $task_details['t1detailed_desc'] ? TextFormatter::render($task_details['t1detailed_desc'], 'task', $task_details['t1id'], $task_details['desccache']) : '<p>'.L('notaskdescription').'</p>'; ?>
		</td>
    		</tr>
	<?php 

		$fl=0;
		endif;

	if ($sl==1 && $l==3): ?>
	<tr id="task<?php echo $task_details['t2id']; ?>" class="sev<?php echo Filters::noXSS($task_details['t2severity']); echo $task_details['t'.$l.'closed']==1 ? ' closed':''; ?>">
		<?php
		if( $task_details['t'.$l.'dep']!=''){
			$deps=explode(',', $task_details['t2dep']);
			foreach($deps as $dep){
				$c[]='{step: "1", tsrc:"t'.$dep.'", fsrc:"", ttgt:"t'.$task_details['t2id'].'", ftgt:""}';
			}
		}

		foreach ($visible as $col):
			if($col == 'progress'):
		?>
			<td class="task_progress" style="min-width:50px;">
			<div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t2percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t2percent_complete']); ?>%"></div></div>
			</td>
			<?php elseif($col=='id'): ?>
			<td style="<?php echo 'background-color:'.$bg[$bgi].';padding-left:20px;'; ?>"><?php echo Filters::noXSS($task_details['t2'.$col]); ?></td>
			<?php elseif ($col=='votes' || $col=='comments' || $col=='attachments' || $col=='parent' || $col=='private' || $col=='duedate' || $col=='dueversion' || $col=='dateclosed' || $col=='closedby' || $col=='editedby' || $col=='estimatedeffort' || $col=='effort'): ?>
			<td class="<?php echo $col; ?>" style="border-top:1px solid #bbb;"><?php echo ($task_details['t2'.$col] >0) ? $task_details['t2'.$col]:''; ?></td>
			<?php elseif ($col=='summary'): ?>
			<td><a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t2id'])); ?>"><?php echo Filters::noXSS($task_details['t2'.$col]); ?></a></td>
			<?php else: ?>
			<td><?php echo Filters::noXSS($task_details['t2'.$col]); ?></td>
			<?php endif; ?>
		<?php endforeach; ?>
		<td style="position:relative;border-top:1px solid #bbb;">
			<div class="gt super" id="t<?php echo $task_details['t2id']; ?>">
			<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t2id'])); ?>"><?php echo Filters::noXSS($task_details['t2summary']); ?></a>
			<?php
			if ($task_details['t2duedate']):
				$due[]='{ tsrc:"t'.$task_details['t2id'].'", duetime:"'.$task_details['t2duedate'].'"}';		
			endif; 
			?>
			</div>
		</td>
		<td id="desc_<?php echo $task_details['t2id']; ?>" class="descbox"><b><?php echo L('taskdescription'); ?></b>
		<?php echo $task_details['t2detailed_desc'] ? TextFormatter::render($task_details['t2detailed_desc'], 'task', $task_details['t2id'], $task_details['desccache']) : '<p>'.L('notaskdescription').'</p>'; ?>
		</td>
    		</tr>
	<?php 
		$sl=0;
	endif;
	?>

	<tr id="task<?php echo $task_details['t'.$l.'id']; ?>" class="sev<?php echo Filters::noXSS($task_details['t'.$l.'severity']); echo $task_details['t'.$l.'closed']==1 ? ' closed':''; ?>">
	<?php
	if( $task_details['t'.$l.'dep']!=''){
		$deps=explode(',', $task_details['t'.$l.'dep']);
		foreach($deps as $dep){
			$c[]='{step: "1", tsrc:"t'.$dep.'", fsrc:"", ttgt:"t'.$task_details['t'.$l.'id'].'", ftgt:""}';
		}
	}

		foreach ($visible as $col):
		if($col == 'progress'):?>
		<td style="min-width:50px;<?php if( $l==1): echo 'border-top:1px solid #bbb;'; endif; ?>" class="task_progress">
		<div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t'.$l.'percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t'.$l.'percent_complete']); ?>%"></div></div>
		</td>
		<?php else: ?>
		<td<?php 
			if(    $col=='id' && $l==2){ echo ' style="padding-left:0px;background-color:'.$bg[$bgi].';"'; }
			elseif($col=='id' && $l==3){ echo ' style="padding-left:40px;background-color:'.$bg[$bgi].';"'; }
			elseif($l==1) { echo ' style="border-top:1px solid #bbb;'; }
	
			if( $col=='id' && $l==1){ echo 'background-color:'.$bg[$bgi].';'; }
			if( $l==1){ echo '"';}
		?>>
			<?php if ($col=='votes' || $col=='comments' || $col=='attachments' || $col=='parent' || $col=='private' || $col=='duedate' || $col=='dueversion' || $col=='dateclosed' || $col=='closedby' || $col=='editedby' || $col=='estimatedeffort' || $col=='effort'): ?>
			<?php echo ($task_details['t'.$l.$col] >0) ? $task_details['t'.$l.$col]:''; ?>

			<?php elseif ($col=='summary'): ?><a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t'.$l.'id'])); ?>"><?php echo Filters::noXSS($task_details['t'.$l.$col]); ?></a>
			<?php else:?>
			<?php echo ($col=='id' && $l==2)? '&#9492; ':''; ?><?php echo Filters::noXSS($task_details['t'.$l.$col]); ?>
<?php 
#print_r($task_details);die(); 
?>
			<?php endif; ?>
		</td>
		<?php endif; ?>
		<?php endforeach; ?>
	<td style="position:relative;width:100%;<?php if( $l==1): echo 'border-top:1px solid #bbb;'; endif; ?>">
		<div class="gt" style="<?php echo $task_details['t'.$l.'dep'] ? 'left:500px;' : 'left:'.rand(0,100).'px'; ?>" id="t<?php echo $task_details['t'.$l.'id']; ?>">
			<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t'.$l.'id'])); ?>"><?php echo Filters::noXSS($task_details['t'.$l.'summary']); ?></a>
		</div>
		<?php
		if ($task_details['t'.$l.'duedate']):
			$due[]='{ tsrc:"t'.$task_details['t'.$l.'id'].'", duetime:"'.$task_details['t'.$l.'duedate'].'"}';
		endif; 
		?>
	</td>
	<td id="desc_<?php echo $task_details['t'.$l.'id']; ?>" class="descbox"><b><?php echo L('taskdescription'); ?></b>
	<?php echo $task_details['t'.$l.'detailed_desc'] ? TextFormatter::render($task_details['t'.$l.'detailed_desc'], 'task', $task_details['t'.$l.'id'], $task_details['t'.$l.'desccache']) : '<p>'.L('notaskdescription').'</p>'; ?>
	</td>
	</tr>
<?php
	$lastsuper=$task_details['t1id'];
	endforeach;
?>
</tbody>
</table>
<canvas id="mycanvas"></canvas>
<div id="lines"></div>
<script src="<?php echo '/'; ?>themes/CleanFS/js/connector.js"></script>
<script>
var canvas;
var context;
c=[ <?php echo implode(',', $c); ?> ];
due=[ <?php echo implode(',', $due); ?> ];
window.onload=init();</script>
<div>
TODO:
<ul>
<li>private task with public subtasks - private task rendered as "ghost" without detailed information</li>
<li>thin (orange?) duedate line "task-------|"</li>
<li>thin red overdue line   "|------today"</li>
<li>dependency/blockers: automatic timeshifted positioning of tasks</li>
<li>priority timeshifted positioning - horizontal floating</li>
<li class="fa fa-check"><s>severity positioning/upfloating; subtasks just within their supertask group</s></li>
<li>task width dependend on estimated effort and work capacity/resources</li>
<li>capacity shifted tasks</li>
<li>assignments to tasks and available work resources for positioning</li>
<li>versions/milestones calculation and layouting</li>
<li>show task assignees as avatars for short column, hover/click shows details of all task assignees</li>
<li>related (and duplicatetask) connections (with an available switch on/off between full view and reduced distraction)</li>
<li>switch between constant and "stretched" timeline. "Stretched" timeline minifies space of low task activity, so more informations are visible on screen.</li>
<li>add modify stuff: add/edit/drop dependencies and relations,
<li>add/adjust/drop explicite duedates</li>
<li>drag task to other task as subtask</li>
<li>drag task out of a supertask (subsubtask follow the dragged out task..)</li>
<li>visualize estimated times of roadmaps/milestones</li>
</ul>
</div>
