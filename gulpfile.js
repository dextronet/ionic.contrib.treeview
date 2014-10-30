var gulp = require('gulp');
var watch = require('gulp-watch');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sourcemaps = require('gulp-sourcemaps');
var coffee = require('gulp-coffee');

var paths = {
  sass: ['./scss/**/*.scss'],
  coffee: [
    './coffee/tree_view_directive.coffee',
    './coffee/tree_view_controller.coffee',
    './coffee/tree_view_view.coffee',
    './coffee/tree_item_directive.coffee',
    './coffee/**/*.coffee'
  ]
};

gulp.task('default', ['sass', 'coffee']);

gulp.task('sass', function(done) {
  gulp.src('./scss/treeview.scss')
    .pipe(sass())
    .pipe(rename({ basename: 'ionic.contrib.treeview' }))
    .pipe(gulp.dest('./src/'))
    .pipe(gulp.dest('./test/treeViewTestApp/www/css'))
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./src/'))
    .pipe(gulp.dest('./test/treeViewTestApp/www/css'))
    .on('end', done);
});

gulp.task('coffee', function(done) {
  gulp.src(paths.coffee)
  .pipe(sourcemaps.init())
  .pipe(coffee({ bare: true }).on('error', gutil.log))
  .pipe(concat('ionic.contrib.treeview.js'))
  .pipe(sourcemaps.write())
  .pipe(gulp.dest('./src', './test/treeViewTestApp/www/lib'))
  .pipe(gulp.dest('./test/treeViewTestApp/www/js'))
  .on('end', done)
})

gulp.task('watch', ['default'], function() {
  watch(paths.sass, function() { gulp.start('sass') });
  watch(paths.coffee, function() { gulp.start('coffee') });
});
