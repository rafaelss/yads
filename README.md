## Yads

Yet Another Deploy Solution is a simple gem to deploy applications using a single YAML file.

## Installation

    group :deploy do
      gem "yads"
    end
    
and

    bundle install

## Usage

- Create the [deploy.yml](http://github.com/rafaelss/yads/blob/examples/deploy.yml) file inside config directory.

- Configure deploy.yml

- Run `bundle exec yads setup` if it's the first deploy you do

- Run `bundle exec yads deploy` to deploy the code and put your application live

## TODO

- Let run commands by name: `yads migrate && yads restart` or `yads migrate restart` like rake tasks
- Separate commands and tasks. Tasks would be commands you could run alone, any time you want

## Maintainer

* Rafael Souza - [rafaelss.com](http://rafaelss.com)

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
