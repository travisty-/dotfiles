# Set up Restic backups to Backblaze B2

How to provision a Backblaze B2 bucket and wire it into the `restic` feature ([`modules/features/services/restic.nix`](../../modules/features/services/restic.nix)). The bucket and its credentials are set up manually; the flake handles the rest.

## 1. Create the bucket

In the B2 console, create a bucket:

- **Name**: Must be globally unique across all of B2 (e.g. `restic-backups-4b1d`).
- **Files in bucket**: Visibility should be set to private.
- **Default encryption**: Enable (SSE-B2). This is optional. Restic already encrypts client-side, so SSE-B2 only adds a redundant second layer.
- **Object Lock**: Disable. Compliance-mode immutability breaks `restic forget --prune`, which must delete and repack pack files.

## 2. Add a lifecycle rule

In the bucket's lifecycle settings, choose **"Keep only the last version of the file"**. By default B2 keeps old versions of overwritten files. Restic overwrites and deletes files during prune, so without this rule those old versions are retained at cost.

## 3. Create an application key

Create an application key **scoped to this bucket** with **Read and Write** capability (read + write + delete; Restic needs delete for prune) and the `listAllBucketNames` permission for the S3-comaptible API. The key's secret is shown once and is unrecoverable.

You get two values:

- **keyID**: `AWS_ACCESS_KEY_ID`
- **applicationKey**: `AWS_SECRET_ACCESS_KEY`

## 4. Note the region

The bucket's S3 endpoint looks like `s3.us-west-004.backblazeb2.com`. The region is the middle segment (`us-west-004`).

## 5. Configure the feature module

In [`modules/features/services/restic.nix`](../../modules/features/services/restic.nix), replace the placeholders in `repository`:

```nix
repository = "s3:s3.${region}.backblazeb2.com/${bucket}/${username}@${hostName}";
                      ^^^^^^                    ^^^^^^
```

## 6. Add the secret values to SOPS

```sh
just sops-edit
```

Add the three values from step 3:

```yaml
AWS_ACCESS_KEY_ID: <keyID>
AWS_SECRET_ACCESS_KEY: <applicationKey>
RESTIC_PASSWORD: <openssl rand -base64 32>
```

## 7. Store a backup of the Restic password

Store **off-machine** (paper, password manager, second device):

- `RESTIC_PASSWORD`: the AES-256 key for the repository. Without it, the backup is unreadable.

If both the password **and** the SSH keys needed to decrypt the SOPS file are lost, the backups would be unrecoverable.

## 8. Upgrade and run the first backup

```sh
just upgrade
sudo systemctl start restic-backups-b2.service
journalctl -fu restic-backups-b2
```

`initialize = true` runs `restic init` on first run; the timer will fire daily.

## 9. Verify restoration works

The `createWrapper` option exposes a `restic-b2` command with the repository and credentials pre-set:

```sh
restic-b2 snapshots
restic-b2 restore latest --target /tmp/restore-test --include /home/$USER/Documents
diff -r /tmp/restore-test/home/$USER/Documents ~/Documents | head
```

Confirm a known file matches, then remove `/tmp/restore-test`. Repeat annually.
