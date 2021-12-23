const config = require('./config.json');


const gulp = require('gulp');
const sourcemaps = require('gulp-sourcemaps');
const clean = require('gulp-clean');
const minifyCSS = require('gulp-clean-css');
const autoprefixer = require('gulp-autoprefixer');
const rename = require('gulp-rename');
const sass = require('gulp-sass');
const iconfont = require('gulp-iconfont');
const iconfontCss = require('gulp-iconfont-css');

sass.compiler = require('node-sass');
const tildeImporter = require('node-sass-tilde-importer');

const onError = (err) => {
    console.log(err);
    this.emit('end');
};

console.log(config);

const compileSass = () => {
    return gulp.src(config.layout.src + '/scss/' + config.layout.css + '.scss')
        .pipe(sass({
            importer: tildeImporter
        }).on('error', sass.logError))
        .pipe(gulp.dest(config.layout.dist + '/css/'))
};

const compileSassSourceMaps = () => {
    return gulp.src(config.layout.src + '/scss/' + config.layout.css + '.scss')
        .pipe(sourcemaps.init())
        .pipe(sass({
            importer: tildeImporter
        }).on('error', sass.logError))
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest(config.layout.dist + '/css/'))
};

const minifyCss = () => {
    return gulp.src(config.layout.dist + '/css/*.css')
        .pipe(minifyCSS({level: {1: {specialComments: 0}}}))
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(gulp.dest(config.layout.dist + '/css/'));
};

const copyAssets = () => {
    return gulp.src(config.layout.src + '/fonts/**/*')
        .pipe(gulp.dest(config.layout.dist + '/fonts/'));
};

const autoprefixCss = () => {
    return gulp.src(config.layout.dist + '/css/*.css')
        .pipe(autoprefixer()).on('error', onError)
        .pipe(gulp.dest(config.layout.dist + '/css/'));
};

const deleteBuildAndDist = () => {
    return gulp.src([
        config.layout.build + "/*",
        config.layout.dist + "/*"
    ]).pipe(clean().on('error', onError));
};

const watchFiles = () => {
    gulp.watch(config.layout.src + "/scss/**/*.scss", gulp.parallel(compileSassSourceMaps));
};

gulp.task('generate-iconfont', function () {
    return gulp.src([config.layout.src + '/icons/*.svg'])
        .pipe(iconfontCss({
            fontName: config.iconfont.name,
            path: config.layout.src + '/scss/template/_icons.scss',
            targetPath: '../../../src/scss/_icons.scss',
            fontPath: '../fonts/icons/'
        }))
        .pipe(iconfont({
            fontName: config.iconfont.name,
            prependUnicode: true,
            formats: ['ttf', 'eot', 'woff', 'woff2', 'svg'],
            fontSize: 1000
        }))
        .pipe(gulp.dest(config.layout.src + '/fonts/icons/'));
});

gulp.task('default',
    gulp.series(
        deleteBuildAndDist,
        copyAssets,
        compileSassSourceMaps,
        watchFiles
    )
);

gulp.task('public',
    gulp.series(
        deleteBuildAndDist,
        copyAssets,
        compileSass,
        autoprefixCss,
        minifyCss
    )
);