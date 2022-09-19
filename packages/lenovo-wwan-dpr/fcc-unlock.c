#include <dlfcn.h>
#include <syslog.h>
#include <stdio.h>
#include <unistd.h>

typedef struct FCC_OPS FCC_OPS;

typedef void *HDMOVERMBIMTOSARHANDLE;

typedef int BOOL;

struct FCC_OPS
{
    int version;
    int size;

    int (*Init)(char *);

    void (*UnInit)(void);

    int (*GetIsMbimReady)(HDMOVERMBIMTOSARHANDLE, BOOL *);

    int (*FccUnlock)(void);
};

FCC_OPS *fcc_ops;

#define MBIM_DEVICE_PATH "/dev/wwan0mbim0"

#define MBIM2SAR_SO_PATH "/bin/mbim2sar.so"

static char *DEVICE_PATH = MBIM_DEVICE_PATH;

int main()
{
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) != NULL)
    {
    }
    else
    {
        perror("getcwd() error");
        return 1;
    }

    strcat(cwd, MBIM2SAR_SO_PATH);

    void *dlHandle = dlopen(cwd, 1);
    if (dlHandle == 0)
    {
        dlclose(dlHandle);
        fprintf(stderr, "dlopen(%s) failed\n", cwd);
        return 1;
    }
    fcc_ops = dlsym(dlHandle, "fcc_ops");
    if (fcc_ops == 0)
    {
        dlclose(dlHandle);
        fprintf(stderr, "dlsym(): could not get 'fcc_ops'\n");
        return 1;
    }
    fcc_ops->Init(DEVICE_PATH);
    int isReady;
    int err = fcc_ops->GetIsMbimReady(0, &isReady);
    for (int i = 0; (err != 0 && (i < 10)); i = i + 1)
    {
        fprintf(stderr, "fcc_ops->GetIsMbimReady(): err=%d. Retrying in 10 seconds...\n", err);
        sleep(10);
        err = fcc_ops->GetIsMbimReady(0, &isReady);
    }
    if (err != 0)
    {
        fprintf(stderr, "fcc_ops-GetISMbimReady() err=%d\n", err);
        goto err_exit;
    }
    if (isReady == 0)
    {
        fprintf(stderr, "fcc_ops->GetIsMbimReady(): never was\n");
        goto err_exit;
    }

    err = fcc_ops->FccUnlock();
    if (err != 0)
    {
        fprintf(stderr, "fcc_ops->FccUnlock() err=%d\n", err);
        fprintf(stderr, "FCC unlock failed\n");
        goto err_exit;
    }

    printf("FCC unlock completed successfully\n");
    fcc_ops->UnInit();
    if (dlHandle != 0)
    {
        dlclose(dlHandle);
        dlHandle = 0;
    }
    return 0;

err_exit:
    fcc_ops->UnInit();
    if (dlHandle != 0)
    {
        dlclose(dlHandle);
        dlHandle = 0;
    }
    return 1;
}