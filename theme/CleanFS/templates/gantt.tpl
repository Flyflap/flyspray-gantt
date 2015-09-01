<?php require_once('permicons.tpl'); ?>
<style>
#tasklist_table {display:inline-block;}
#tasklist_table thead {max-width:50px;width:50px;overflow:hidden;text-overflow:hidden;}
#tasklist_table td, #tasklist_table th{width:50px;}
</style>
<table id="tasklist_table">
<colgroup>
        <col class="caret" />
        <?php if (!$user->isAnon() && $proj->id !=0): ?><col class="toggle" /><?php endif; ?>
        <?php foreach ($visible as $col): ?>
        <col class="<?php echo $col; ?>" />
        <?php endforeach; ?>
</colgroup>
<colgroup width="100%"><col /></colgroup>
<thead>
    <tr>
        <?php foreach ($visible as $col):
                if($col=='progress'): echo '<th style="width:50px;">'.Filters::noXSS(L($col)).'</th>';
                elseif($col=='comments'): echo '<th style="width:50px;"><i class="fa fa-comments"></i></th>';
                elseif($col=='dateopened'): echo '<th style="width:50px;"><i class="fa fa-calendar-o"></i></th>';
                elseif($col=='lastedit'): echo '<th style="width:50px;"><i class="fa fa-calendar-o"></i></th>';
                elseif($col=='duedate'): echo '<th style="width:50px;"><i class="fa fa-calendar-o"></i></th>';
                elseif($col=='dateclosed'): echo '<th style="width:50px;"><i class="fa fa-calendar-o"></i></th>';
                elseif($col=='private'): echo '<th style="width:50px;"><i class="fa fa-lock"></i></th>';
                elseif($col=='votes'): echo '<th style="width:50px;"><i class="fa fa-star"></i></th>';
                elseif($col=='parent'): echo '<th style="width:50px;"><i class="fa fa-level-up fa-flip-horizontal"></i></th>';
                elseif($col=='effort'): echo '<th style="width:50px;"><i class="fa fa-clock-o"></i></th>';
                elseif($col=='estimatedeffort'): echo '<th style="width:50px;"><i class="fa fa-clock-o"></i></th>';
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
                <tr id="task<?php echo $task_details['t1id']; ?>"<?php echo $task_details['t'.$l.'closed']==1 ? 'style="text-decoration:line-through;"':''; ?> class="severity<?php echo Filters::noXSS($task_details['t1severity']); ?>" >
                <?php foreach ($visible as $col):
                        if($col == 'progress'):
                ?>
                        <td style="border-top:1px solid #bbb;min-width:50px;" class="task_progress">
                        <div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t1percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t1percent_complete']); ?>%"></div></div>
                        </td>
                        <?php elseif($col=='id'): ?>
                        <td style="<?php echo 'background-color:'.$bg[$bgi]; ?>"><?php echo Filters::noXSS($task_details['t1'.$col]); ?></td>
                        <?php else: ?>
                        <td style="border-top:1px solid #bbb;"><?php echo Filters::noXSS($task_details['t1'.$col]); ?></td>
                        <?php endif; ?>
                <?php endforeach; ?>
                <td id="desc_<?php echo $task_details['t1id']; ?>" class="descbox box">
                <b><?php echo L('taskdescription'); ?></b>
                <?php echo $task_details['t1detailed_desc'] ? TextFormatter::render($task_details['t1detailed_desc'], 'task', $task_details['t1id'], $task_details['desccache']) : '<p>'.L('notaskdescription').'</p>'; ?>
                </td>
                <td style="width:100%;border-top:1px solid #bbb;"></td>
                </tr>
        <?php

        $fl=0;
        endif;

        if ($sl==1 && $l==3): ?>
        <tr  id="task<?php echo $task_details['t2id']; ?>"<?php echo $task_details['t'.$l.'closed']==1 ? ' style="text-decoration:line-through;"':''; ?>" class="severity<?php echo Filters::noXSS($task_details['t2severity']); ?>" >
                <?php foreach ($visible as $col):
                        if($col == 'progress'):
                ?>
                        <td class="task_progress" style="min-width:50px;">
                        <div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t2percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t2percent_complete']); ?>%"></div></div>
                        </td>
                        <?php elseif($col=='id'): ?>
                        <td style="<?php echo 'background-color:'.$bg[$bgi]; ?>"><?php echo Filters::noXSS($task_details['t1'.$col]); ?></td>
                        <?php else: ?>
                        <td><?php echo Filters::noXSS($task_details['t2'.$col]); ?></td>
                        <?php endif; ?>
                <?php endforeach; ?>
                <td id="desc_<?php echo $task_details['t2id']; ?>" class="descbox box">
                <b><?php echo L('taskdescription'); ?></b>
                <?php echo $task_details['t2detailed_desc'] ? TextFormatter::render($task_details['t2detailed_desc'], 'task', $task_details['t2id'], $task_details['desccache']) : '<p>'.L('notaskdescription').'</p>'; ?>
                </td>
                </tr>
        <?php
                $sl=0;
                endif;
        ?>
        <tr id="task<?php echo $task_details['t'.$l.'id']; ?>"<?php echo $task_details['t'.$l.'closed']==1 ? 'style="text-decoration:line-through;"':''; ?> class="severity<?php echo Filters::noXSS($task_details['t'.$l.'severity']); ?>" >
        <?php foreach ($visible as $col):
                if($col == 'progress'):
        ?>
                <td style="min-width:50px;<?php if( $l==1): echo 'border-top:1px solid #bbb;"'; endif; ?>" class="task_progress">
                <div class="progress_bar_container"><span><?php echo Filters::noXSS($task_details['t'.$l.'percent_complete']); ?>%</span><div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['t'.$l.'percent_complete']); ?>%"></div></div>
                </td>
                <?php else: ?>
                <td<?php
                        if(    $col=='id' && $l==2){ echo ' style="padding-left:0px;background-color:'.$bg[$bgi].';"'; }
                        elseif($col=='id' && $l==3){ echo ' style="padding-left:40px;background-color:'.$bg[$bgi].';"'; }
                        elseif($l==1) { echo ' style="border-top:1px solid #bbb;'; }
                        if( $col=='id' && $l==1){ echo 'background-color:'.$bg[$bgi].';'; }
                        if( $l==1){ echo '"';}
                 ?>><?php echo ($col=='id' && $l==2)? '&#9492; ':''; ?><?php echo Filters::noXSS($task_details['t'.$l.$col]); ?></td>
                <?php endif;
        endforeach; ?>
        <td style="width:100%;<?php if( $l==1): echo 'border-top:1px solid #bbb;'; endif; ?>"></td>
        <td id="desc_<?php echo $task_details['t1id']; ?>" class="descbox box">
        <b><?php echo L('taskdescription'); ?></b>
        <?php echo $task_details['t1detailed_desc'] ? TextFormatter::render($task_details['t1detailed_desc'], 'task', $task_details['t1id'], $task_details['desccache']) : '<p>'.L('notaskdescription').'</p>'; ?>
        </td>
        </tr>
<?php
        $lastsuper=$task_details['t1id'];
        endforeach;
?>
</tbody>
</table>
