<?php
/**
 * The footer template file.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
?>
<div id="wrapper-footer">
<div class="wrapper-top-line">
  <div id="footer">
    <div class="footer-widget-area footer-widget-area-1">
<?php if ( dynamic_sidebar( 'sidebar-3' ) ) : else : ?>
<?php endif; ?>
    </div>
    
    <div class="footer-widget-area footer-widget-area-2">
<?php if ( dynamic_sidebar( 'sidebar-4' ) ) : else : ?>
<?php endif; ?>
    </div>
    
    <div class="footer-widget-area footer-widget-area-3">
<?php if ( dynamic_sidebar( 'sidebar-5' ) ) : else : ?>
<?php endif; ?>
    </div>
  </div>
<?php if ( dynamic_sidebar( 'sidebar-6' ) ) : else : ?>
<?php endif; ?>
</div>
</div>  <!-- end of wrapper-footer -->

<?php wp_footer(); ?>      
</body>
</html>