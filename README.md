# diff-apk
A github action to view the impact of a code change on the apk. 

## How does it work?
diff-apk does a few things:
- It gets the SHA of the commit where the running branch was branched off. Here it assumes that the apk are stored with the same name as the 
SHA of the commit on the main branch.
- It downloads the artifact and unzips it.
- It then goes on to use [Diffuse](https://github.com/JakeWharton/diffuse) underneath. Diffuse does all the heavy lifting of analysing the differences 
between the APKs and surfacing them. 
- It then comments the output on the PR using [Create and Update Comment](https://github.com/marketplace/actions/create-or-update-comment) github action.

## diff-apk works best when 
- the apks are uploaded and stored with the SHA of the commit on main.
- it's run on non main branches.
- the checkout is done with the pull request head sha so the branched off sha can be calculated.

## How to use?
- Add the following steps in the workflow:

```
- name: Upload APK
        if: ${{ github.ref == 'refs/heads/main' }}
        uses: actions/upload-artifact@v3
        with:
          name: ${{ github.sha }}
          path: androidApp/build/outputs/apk/debug/*.apk
          if-no-files-found: error

- name: Diff APK
        if: ${{ github.ref != 'refs/heads/main' }}
        uses: doublesymmetry/diff-apk@main
        with:
          github_token: ${{secrets.GITHUB_TOKEN}}
          new_apk: androidApp/build/outputs/apk/debug/*.apk
 ```

- Update the checkout step to have the PR head as ref and fetch-depth of 0.

```
- name: Checkout Repo
        uses: actions/checkout@v3
        with:
          ref: ${{ github.event.pull_request.head.sha }}
          fetch-depth: 0
```

## How does the comment look like?
[Example PR comment with diffuse output](images/example-diff-output.png)
