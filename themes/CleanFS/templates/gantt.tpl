<?php
/* Author: Peter Liscovius */
require_once('permicons.tpl'); ?>
<style>
#content{position:relative;}
#tasklist_table {display:inline-block;}
#tasklist_table tbody tr.private {background: repeating-linear-gradient(135deg, #ccc, #ccc .25em, #fff 0, #fff .75em); opacity:0.8; }
#tasklist_table thead {overflow:hidden;text-overflow:hidden;}
#tasklist_table td, #tasklist_table th{line-height:1;padding-right:4px;padding-left:4px;width:60px;white-space:nowrap;overflow:hidden;max-width:60px;}
#tasklist_table td.avatar {padding:0;}
#tasklist_table th {background:rgba(255,255,255,0.4);}
td.avatar a i { color:#ccc;padding-left:2px;vertical-align:top; }
td.gantt { position:relative;min-width:1000px; }
.gt{display:inline-block;width:4px;position:absolute;top:0;background-color:#0cf;border-radius:2px;}
.gt a{color:#000;}
.gt.super{width:150px;}
tr.closed {opacity:0.4;}
tr.closed a {text-decoration:line-through;}
#mycanvas{position:absolute;top:0;left:0;z-index:-1;}

#colmenu ~ input[type="checkbox"], #colmenu ~ input[type="radio"], #colmenu ~ label {display:none;}
#colmenu + label {display:inline-block;}
#colmenu:checked ~ input[type="checkbox"], #colmenu:checked ~ input[type="radio"], #colmenu:checked ~ label {display:inline-block;}

col.id,
col.project,
col.summary,
col.parent,
col.priority,
col.category,
col.severity,
col.tasktype,
col.progress,
col.status,
col.dateclosed,
col.private,
col.openedby,
col.editedby,
col.closedby,
col.attachments,
col.assignedto,
col.lastedit,
col.dateopened,
col.dueversion,
col.duedate,
col.reportedin,
col.comments,
col.votes,
col.os,
col.effort,
col.estimatedeffort{
	visibility:collapse;
}

#hideall:checked ~ table col.id,
#hideall:checked ~ table col.project,
#hideall:checked ~ table col.summary,
#hideall:checked ~ table col.parent,
#hideall:checked ~ table col.priority,
#hideall:checked ~ table col.category,
#hideall:checked ~ table col.severity,
#hideall:checked ~ table col.tasktype,
#hideall:checked ~ table col.progress,
#hideall:checked ~ table col.status,
#hideall:checked ~ table col.dateclosed,
#hideall:checked ~ table col.private,
#hideall:checked ~ table col.openedby,
#hideall:checked ~ table col.editedby,
#hideall:checked ~ table col.closedby,
#hideall:checked ~ table col.attachments,
#hideall:checked ~ table col.assignedto,
#hideall:checked ~ table col.lastedit,
#hideall:checked ~ table col.dateopened,
#hideall:checked ~ table col.dueversion,
#hideall:checked ~ table col.duedate,
#hideall:checked ~ table col.reportedin,
#hideall:checked ~ table col.comments,
#hideall:checked ~ table col.votes,
#hideall:checked ~ table col.os,
#hideall:checked ~ table col.effort,
#hideall:checked ~ table col.estimatedeffort {
	visibility:collapse !important;
}

#showall:checked ~ table col.id,         #id:checked ~ table col.id,
#showall:checked ~ table col.project,    #project:checked ~ table col.project,
#showall:checked ~ table col.summary,    #summary:checked ~ table col.summary,
#showall:checked ~ table col.parent,     #parent:checked ~ table col.parent,
#showall:checked ~ table col.priority,   #priority:checked ~ table col.priority,
#showall:checked ~ table col.category,   #category:checked ~ table col.category,
#showall:checked ~ table col.severity,   #severity:checked ~ table col.severity,
#showall:checked ~ table col.tasktype,   #tasktype:checked ~ table col.tasktype,
#showall:checked ~ table col.progress,   #progress:checked ~ table col.progress,
#showall:checked ~ table col.status,     #status:checked ~ table col.status,
#showall:checked ~ table col.dateclosed, #dateclosed:checked ~ table col.dateclosed,
#showall:checked ~ table col.private,    #private:checked ~ table col.private,
#showall:checked ~ table col.openedby,   #openedby:checked ~ table col.openedby,
#showall:checked ~ table col.editedby,   #editedby:checked ~ table col.editedby,
#showall:checked ~ table col.closedby,   #closedby:checked ~ table col.closedby,
#showall:checked ~ table col.attachments,#attachments:checked ~ table col.attachments,
#showall:checked ~ table col.assignedto, #assignedto:checked ~ table col.assignedto,
#showall:checked ~ table col.lastedit,   #lastedit:checked ~ table col.lastedit,
#showall:checked ~ table col.dateopened, #dateopened:checked ~ table col.dateopened,
#showall:checked ~ table col.dueversion, #dueversion:checked ~ table col.dueversion,
#showall:checked ~ table col.duedate,    #duedate:checked ~ table col.duedate,
#showall:checked ~ table col.reportedin, #reportedin:checked ~ table col.reportedin,
#showall:checked ~ table col.comments,   #comments:checked ~ table col.comments,
#showall:checked ~ table col.votes,      #votes:checked ~ table col.votes,
#showall:checked ~ table col.os,         #os:checked ~ table col.os,
#showall:checked ~ table col.effort,     #effort:checked ~ table col.effort,
#showall:checked ~ table col.estimatedeffort, #estimatedeffort:checked ~ table col.estimatedeffort {
	visibility:visible;
}

#hideall, #showall, #unset {visibility:collapse;position:absolute;}

#colmenu ~ #hidealllabel, #colmenu ~ #showalllabel, #colmenu ~ #unsetlabel {display:none;}
#hideall:checked ~ #showalllabel {display:inline;padding:2px;border:none;}
#showall:checked ~ #unsetlabel   {display:inline;padding:2px;border:none;}
#unset:checked   ~ #hidealllabel {display:inline;padding:2px;border:none;}

#hideclosed:checked ~ table tr.closed {visibility:collapse;}
#hideprivate:checked ~ table tr.private {visibility:collapse;}
#hidesubs:checked ~ table tr.sub {visibility:collapse;}

</style>

<input type="checkbox" name="colmenu" id="colmenu">
<label for="colmenu"><?php echo L('customize'); ?></label>

<input type="checkbox" name="hideclosed" id="hideclosed">
<label for="hideclosed" id="hideclosedlabel"><?php echo L('hideclosed'); ?></label>

<input type="checkbox" name="hideprivate" id="hideprivate">
<label for="hideprivate" id="hideprivatelabel"><?php echo L('hideprivate'); ?></label>

<input type="checkbox" name="hidesubs" id="hidesubs">
<label for="hidesubs" id="hidesubslabel"><?php echo L('hidesubs'); ?></label>

<input type="radio" name="show" id="hideall">
<input type="radio" name="show" id="showall">
<input type="radio" name="show" id="unset" checked="checked">
<label class="button" for="hideall" id="hidealllabel"><?php echo L('hide'); ?></label>
<label class="button" for="showall" id="showalllabel"><?php echo L('show'); ?></label>
<label class="button" for="unset" id="unsetlabel"><?php echo L('custom'); ?></label>
<input type="checkbox" name="id" id="id"<?php echo array_search('id',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="id"><?php echo L('id'); ?></label>
<input type="checkbox" name="project" id="project"<?php echo array_search('project',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="project"><?php echo L('project'); ?></label>
<input type="checkbox" name="summary" id="summary"<?php echo array_search('summary',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="summary"><?php echo L('summary'); ?></label>
<input type="checkbox" name="parent" id="parent"<?php echo array_search('parent',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="parent"><?php echo L('parent'); ?></label>
<input type="checkbox" name="priority" id="priority"<?php echo array_search('priority',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="priority"><?php echo L('priority'); ?></label>
<input type="checkbox" name="category" id="category"<?php echo array_search('category',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="category"><?php echo L('category'); ?></label>
<input type="checkbox" name="severity" id="severity"<?php echo array_search('severity',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="severity"><?php echo L('severity'); ?></label>
<input type="checkbox" name="tasktype" id="tasktype"<?php echo array_search('tasktype',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="tasktype"><?php echo L('tasktype'); ?></label>
<input type="checkbox" name="progress" id="progress"<?php echo array_search('progress',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="progress"><?php echo L('progress'); ?></label>
<input type="checkbox" name="status" id="status"<?php echo array_search('status',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="status"><?php echo L('status'); ?></label>
<input type="checkbox" name="dateclosed" id="dateclosed"<?php echo array_search('dateclosed',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="dateclosed"><?php echo L('dateclosed'); ?></label>
<input type="checkbox" name="private" id="private"<?php echo array_search('private',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="private"><?php echo L('private'); ?></label>
<input type="checkbox" name="openedby" id="openedby"<?php echo array_search('openedby',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="openedby"><?php echo L('openedby'); ?></label>
<input type="checkbox" name="editedby" id="editedby"<?php echo array_search('editedby',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="editedby"><?php echo L('editedby'); ?></label>
<input type="checkbox" name="closedby" id="closedby"<?php echo array_search('closedby',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="closedby"><?php echo L('closedby'); ?></label>
<input type="checkbox" name="attachments" id="attachments"<?php echo array_search('attachments',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="attachments"><?php echo L('attachments'); ?></label>
<input type="checkbox" name="assignedto" id="assignedto"<?php echo array_search('assignedto',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="assignedto"><?php echo L('assignedto'); ?></label>
<input type="checkbox" name="lastedit" id="lastedit"<?php echo array_search('lastedit',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="lastedit"><?php echo L('lastedit'); ?></label>
<input type="checkbox" name="dateopened" id="dateopened"<?php echo array_search('dateopened',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="dateopened"><?php echo L('dateopened'); ?></label>
<input type="checkbox" name="dueversion" id="dueversion"<?php echo array_search('dueversion',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="dueversion"><?php echo L('dueversion'); ?></label>
<input type="checkbox" name="duedate" id="duedate"<?php echo array_search('duedate',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="duedate"><?php echo L('duedate'); ?></label>
<input type="checkbox" name="reportedin" id="reportedin"<?php echo array_search('reportedin',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="reportedin"><?php echo L('reportedin'); ?></label>
<input type="checkbox" name="comments" id="comments"<?php echo array_search('comments',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="comments"><?php echo L('comments'); ?></label>
<input type="checkbox" name="votes" id="votes"<?php echo array_search('votes',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="votes"><?php echo L('votes'); ?></label>
<input type="checkbox" name="os" id="os"<?php echo array_search('os',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="os"><?php echo L('os'); ?></label>
<input type="checkbox" name="effort" id="effort"<?php echo array_search('effort',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="effort"><?php echo L('effort'); ?></label>
<input type="checkbox" name="estimatedeffort" id="estimatedeffort"<?php echo array_search('estimatedeffort',$visible)!==false ? ' checked="checked"':''; ?>>
<label for="estimatedeffort"><?php echo L('estimatedeffort'); ?></label>
<table id="tasklist_table">
<colgroup>
<!--	<col class="caret" /> -->
<!--	<?php if (!$user->isAnon() && $proj->id !=0): ?><col class="toggle" /><?php endif; ?> -->
	<?php foreach ($visible as $col): ?>
        <col class="<?php echo $col; ?>" />
        <?php endforeach; ?>
</colgroup>
<colgroup width="100%"><col /></colgroup>
<thead>
<tr>
<?php 
foreach ($visible as $col):
		if($col=='progress'): echo '<th style="width:50px;">'.Filters::noXSS(L($col)).'</th>';
		elseif($col=='comments'): echo '<th style="width:50px;" title="'.eL('comments').'"><i class="fa fa-comments"></i></th>';
		elseif($col=='dateopened'): echo '<th style="width:60px;" title="'.eL('opened').'"><i class="fa fa-calendar-o"></i></th>';
		elseif($col=='lastedit'): echo '<th style="width:60px;" title="'.eL('lastedit').'"><i class="fa fa-calendar-o"></i></th>';
		elseif($col=='duedate'): echo '<th style="width:60px;" title="'.eL('duedate').'"><i class="fa fa-calendar-o"></i></th>';
		elseif($col=='dateclosed'): echo '<th style="width:60px;" title="'.eL('dateclosed').'"><i class="fa fa-calendar-o"></i></th>';
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
$related=array(); # fuer canvas related tasks lines
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
		<tr id="task<?php echo $task_details['t1id']; ?>" class="sev<?php echo Filters::noXSS($task_details['t1severity']); echo $task_details['t1closed']==1 ? ' closed':'';  echo $task_details['t1private']==1 ? ' private':''; ?>">
		<?php
		if( $task_details['t'.$l.'dep']!=''){
			$deps=explode(',', $task_details['t1dep']);
			foreach($deps as $dep){
				$c[]='{step: "1", tsrc:"t'.$dep.'", fsrc:"", ttgt:"t'.$task_details['t1id'].'", ftgt:""}';
			}
		}
		if( $task_details['t'.$l.'rel']!=''){
			$rels=explode(',', $task_details['t1rel']);
			foreach($rels as $rel){
				$related[]='{step: "1", tsrc:"t'.$rel.'", fsrc:"", ttgt:"t'.$task_details['t1id'].'", ftgt:""}';
			}
		}

		foreach ($visible as $col): ?>
		<td<?php
			if($col == 'progress'){
				echo ' class="task_progress" style="min-width:50px;"'; 
			} elseif($col=='id') {
				echo ' style="background-color:'.$bg[($bgi%8)].'"'; 
			} elseif($col=='openedby' || $col=='editedby' || $col=='closedby' || $col=='assignedto') {
				echo ' class="avatar"';
			} elseif($col=='severity' || $col=='priority') {
				echo ' class="task_'.$col.' '.substr($col,0,3).$task_details['t1'.$col].'"';
			} elseif($col=='tasktype') {
				echo ' class="task_'.$col.' typ'.$task_details['t1'.$col].'"';
			} else {
				echo ' class="'.$col.'" style="border-top:1px solid #bbb;"';
			}
		?>>
			<?php if($col == 'progress'): ?>
				<div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t1percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t1percent_complete']); ?>%"></div></div>
			<?php elseif ($col=='id'): ?>
				<?php echo $task_details['t1'.$col]; ?>
			<?php elseif ($col=='votes' || $col=='comments' || $col=='attachments' || $col=='parent' || $col=='private' || $col=='dueversion' || $col=='estimatedeffort' || $col=='effort'): ?>
				<?php echo ($task_details['t1'.$col] >0) ? $task_details['t1'.$col]:''; ?>
			<?php elseif ($col=='openedby' || $col=='editedby' || $col=='closedby'): ?><?php echo ($task_details['t1'.$col]> 0) ? tpl_userlinkavatar($task_details['t1'.$col],24):''; ?>
			<?php elseif ($col=='assignedto'): ?><?php
				$assis=explode(',',$task_details['t1'.$col]);
				foreach($assis as $a){ echo $a>0 ? tpl_userlinkavatar($a,24):''; }
			 ?>
			<?php elseif ($col=='dateopened' || $col=='lastedit' || $col=='duedate' || $col=='dateclosed'): ?><?php echo ($task_details['t1'.$col]> 0) ? formatDate($task_details['t1'.$col],true):''; ?>
			<?php elseif ($col=='summary'): ?>
				<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t1id'])); ?>"><?php echo Filters::noXSS($task_details['t1'.$col]); ?></a>
			<?php else: ?>
				<?php echo Filters::noXSS($task_details['t1'.$col]); ?>
			<?php endif; ?>
		</td>
		<?php endforeach; ?>
		<td class="gantt">
			<div class="gt super" id="t<?php echo $task_details['t1id']; ?>">
			<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t1id'])); ?>"><?php echo Filters::noXSS($task_details['t1summary']); ?></a>
			</div>
			<?php
			if ($task_details['t1duedate']):
				$due[]='{ tsrc:"t'.$task_details['t1id'].'", duetime:"'.$task_details['t1duedate'].'"}';		
			endif; 
			?>
		</td>
    		</tr>
	<?php 

		$fl=0;
		endif;

	if ($sl==1 && $l==3): ?>
	<tr id="task<?php echo $task_details['t2id']; ?>" class="sev<?php echo Filters::noXSS($task_details['t2severity']); echo $task_details['t'.$l.'closed']==1 ? ' closed':''; echo $task_details['t2private']==1 ? ' private':'';?>">
		<?php
		if( $task_details['t'.$l.'dep']!=''){
			$deps=explode(',', $task_details['t2dep']);
			foreach($deps as $dep){
				$c[]='{step: "1", tsrc:"t'.$dep.'", fsrc:"", ttgt:"t'.$task_details['t2id'].'", ftgt:""}';
			}
		}
		if( $task_details['t'.$l.'rel']!=''){
			$rels=explode(',', $task_details['t2rel']);
			foreach($rels as $rel){
				$related[]='{step: "1", tsrc:"t'.$rel.'", fsrc:"", ttgt:"t'.$task_details['t2id'].'", ftgt:""}';
			}
		}

		foreach ($visible as $col): ?>
		<td<?php
			if($col == 'progress'){
				echo ' class="task_progress" style="min-width:50px;"'; 
			} elseif($col=='id') {
				echo ' style="background-color:'.$bg[($bgi%8)].';padding-left:20px;"'; 
			} elseif($col=='openedby' || $col=='editedby' || $col=='closedby' || $col=='assignedto') {
				echo ' class="avatar"';
			} elseif($col=='severity' || $col=='priority') {
				echo ' class="task_'.$col.' '.substr($col,0,3).$task_details['t2'.$col].'"';
			} elseif($col=='tasktype') {
				echo ' class="task_'.$col.' typ'.$task_details['t2'.$col].'"';
			} else {
				echo ' class="'.$col.'" style="border-top:1px solid #bbb;"';
			}
		?>>	
			<?php if($col == 'progress'): ?>
				<div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t2percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t2percent_complete']); ?>%"></div></div>
			<?php elseif ($col=='votes' || $col=='comments' || $col=='attachments' || $col=='parent' || $col=='private' || $col=='dueversion' || $col=='estimatedeffort' || $col=='effort'): ?>
				<?php echo ($task_details['t2'.$col] >0) ? $task_details['t2'.$col]:''; ?>
			<?php elseif ($col=='openedby' || $col=='editedby' || $col=='closedby'): ?><?php echo ($task_details['t2'.$col]> 0) ? tpl_userlinkavatar($task_details['t2'.$col],24):''; ?>
			<?php elseif ($col=='assignedto'): ?><?php
				$assis=explode(',',$task_details['t2'.$col]);
				foreach($assis as $a){ echo $a>0 ? tpl_userlinkavatar($a,24):''; }
			 ?>
			<?php elseif ($col=='dateopened' || $col=='lastedit' || $col=='duedate' || $col=='dateclosed'): ?><?php echo ($task_details['t2'.$col]> 0) ? formatDate($task_details['t2'.$col],true):''; ?>
			<?php elseif ($col=='summary'): ?>
				<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t2id'])); ?>"><?php echo Filters::noXSS($task_details['t2'.$col]); ?></a>
			<?php else: ?>
			<?php echo Filters::noXSS($task_details['t2'.$col]); ?>
			<?php endif; ?>
		</td>
		<?php endforeach; ?>
		<td class="gantt">
			<div class="gt super" id="t<?php echo $task_details['t2id']; ?>">
			<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t2id'])); ?>"><?php echo Filters::noXSS($task_details['t2summary']); ?></a>
			<?php
			if ($task_details['t2duedate']):
				$due[]='{ tsrc:"t'.$task_details['t2id'].'", duetime:"'.$task_details['t2duedate'].'"}';		
			endif; 
			?>
			</div>
		</td>
    		</tr>
	<?php 
		$sl=0;
	endif;
	?>

	<tr id="task<?php echo $task_details['t'.$l.'id']; ?>" class="<?php echo ($l==2 || $l==3)? 'sub ':''; ?>sev<?php echo Filters::noXSS($task_details['t'.$l.'severity']); echo $task_details['t'.$l.'closed']==1 ? ' closed':''; echo $task_details['t'.$l.'private']==1 ? ' private':''; ?>">
	<?php
	if( $task_details['t'.$l.'dep']!=''){
		$deps=explode(',', $task_details['t'.$l.'dep']);
		foreach($deps as $dep){
			$c[]='{step: "1", tsrc:"t'.$dep.'", fsrc:"", ttgt:"t'.$task_details['t'.$l.'id'].'", ftgt:""}';
		}
	}
	if( $task_details['t'.$l.'rel']!=''){
		$rels=explode(',', $task_details['t'.$l.'rel']);
		foreach($rels as $rel){
			$related[]='{step: "1", tsrc:"t'.$rel.'", fsrc:"", ttgt:"t'.$task_details['t'.$l.'id'].'", ftgt:""}';
		}
	}

		foreach ($visible as $col):
		if($col == 'progress'):?>
		<td style="min-width:50px;<?php if( $l==1): echo 'border-top:1px solid #bbb;'; endif; ?>" class="task_progress">
		<div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t'.$l.'percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t'.$l.'percent_complete']); ?>%"></div></div>
		</td>
		<?php else: ?>
		<td<?php 
			if(    $col=='id' && $l==2){ echo ' style="padding-left:0px;background-color:'.$bg[($bgi%8)].';"'; }
			elseif($col=='id' && $l==3){ echo ' style="padding-left:40px;background-color:'.$bg[($bgi%8)].';"'; }
			elseif($l==1) { echo ' style="border-top:1px solid #bbb;'; }
	
			if( $col=='id' && $l==1){ echo 'background-color:'.$bg[($bgi%8)].';'; }
			if( $l==1){ echo '"';}
		
			if ($col=='openedby' || $col=='editedby' || $col=='closedby' || $col=='assignedto') {
				echo ' class="avatar"';
			} elseif ($col=='severity' || $col=='priority') {
				echo ' class="task_'.$col.' '.substr($col,0,3).$task_details['t'.$l.$col].'"';
			} elseif($col=='tasktype') {
				echo ' class="task_'.$col.' typ'.$task_details['t'.$l.$col].'"';
			}
		?>>
			<?php if ($col=='votes' || $col=='comments' || $col=='attachments' || $col=='parent' || $col=='private' || $col=='dueversion' || $col=='estimatedeffort' || $col=='effort'): ?>
			<?php echo ($task_details['t'.$l.$col] >0) ? $task_details['t'.$l.$col]:''; ?>
			<?php elseif ($col=='openedby' || $col=='editedby' || $col=='closedby'): ?><?php echo ($task_details['t'.$l.$col]> 0) ? tpl_userlinkavatar($task_details['t'.$l.$col],24):''; ?>
			<?php elseif ($col=='assignedto'): ?><?php
				$assis=explode(',',$task_details['t'.$l.$col]);
				foreach($assis as $a){ echo $a>0 ? tpl_userlinkavatar($a,24):''; }
			 ?>
			<?php elseif ($col=='dateopened' || $col=='lastedit' || $col=='duedate' || $col=='dateclosed'): ?><?php echo ($task_details['t'.$l.$col]> 0) ? formatDate($task_details['t'.$l.$col],true):''; ?>
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
	<td class="gantt" style="<?php if( $l==1): echo 'border-top:1px solid #bbb;'; endif; ?>">
		<div class="gt" style="width:50px;<?php echo $task_details['t'.$l.'dep'] ? 'left:400px;' : 'left:'.rand(10,10).'px'; ?>" id="t<?php echo $task_details['t'.$l.'id']; ?>">
			<a href="<?php echo Filters::noXSS(CreateURL('details', $task_details['t'.$l.'id'])); ?>"><?php echo Filters::noXSS($task_details['t'.$l.'summary']); ?></a>
		</div>
		<?php
		if ($task_details['t'.$l.'duedate']):
			$due[]='{ tsrc:"t'.$task_details['t'.$l.'id'].'", duetime:"'.$task_details['t'.$l.'duedate'].'"}';
		endif; 
		?>
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
<script src="<?php echo '/'; ?>themes/CleanFS/jsconnector.js"></script>
<script>
var canvas;
var context;
c=[ <?php echo implode(',', $c); ?> ];
r=[ <?php echo implode(',', $related); ?> ];
due=[ <?php echo implode(',', $due); ?> ];
today=<?php echo time(); ?>;
window.onload=init();</script>
<div>
TODO:
<ul>
<li>private task with public subtasks - private task rendered as "ghost" without detailed information</li>
<li><s class="fa fa-check">thin duedate line</s></li>
<li><s class="fa fa-check">red overdue line</s></li>
<li>dependency/blockers: automatic timeshifted positioning of tasks</li>
<li>priority timeshifted positioning - horizontal floating</li>
<li class="fa fa-check"><s>severity positioning/upfloating; subtasks just within their supertask group</s></li>
<li>task width dependend on estimated effort and work capacity/resources</li>
<li>capacity shifted tasks</li>
<li>assignments to tasks and available work resources for positioning</li>
<li>versions/milestones calculation and layouting</li>
<li><s class="fa fa-check">show task assignees as avatars</s> for short column, hover/click shows details of all task assignees</li>
<li>related (and duplicatetask) connections (with an available switch on/off between full view and reduced distraction)</li>
<li>switch between constant and "stretched" timeline. "Stretched" timeline minifies space of low task activity, so more informations are visible on screen.</li>
<li>add modify stuff: add/edit/drop dependencies and relations,
<li>add/adjust/drop explicite duedates</li>
<li>drag task to other task as subtask</li>
<li>drag task out of a supertask (subsubtask follow the dragged out task..)</li>
<li>visualize estimated times of roadmaps/milestones</li>
</ul>
</div>
